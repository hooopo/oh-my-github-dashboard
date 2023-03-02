import * as fsp from 'node:fs/promises';
import * as path from 'node:path';
import * as process from 'node:process';
import { init } from 'echarts';
import '../../api-vis/theme.js';

const handler = async function (req, res) {
  const root = process.cwd();
  const buildDir = path.join(root, 'build');
  const apiDir = path.join(buildDir, 'api');

  const { id, w = '480', h = '320' } = req.query;

  const promises: Promise<any>[] = [];

  for (const dirent of await fsp.readdir(apiDir, { withFileTypes: true })) {
    if (dirent.isFile() && dirent.name.endsWith('.json')) {
      promises.push(fsp.readFile(path.join(apiDir, dirent.name), { encoding: 'utf-8' }).then(JSON.parse).then(json => findDataJson(id, json)));
    }
  }

  const result = (await Promise.all(promises)).find(item => item != null);
  if (!result) {
    res.status(404).send('Query not found');
    return;
  }

  const template = await getTemplate(id, buildDir);
  if (!template) {
    res.status(404).send('Visualization template not provided');
    return;
  }

  const ec = init(null, 'evidence-light', {
    renderer: 'svg',
    ssr: true,
    width: parseInt(w),
    height: parseInt(h),
  });

  ec.setOption(template(result.data));

  res.status(200).setHeader('content-type', 'image/svg+xml').send(ec.renderToSVGString());
};

type EvidenceDataJson = {
  data: {
    evidencemeta?: {
      [key: string]: any
      queries: {
        id: string
        [key: string]: any
      }[]
    }
  }
}

async function findDataJson (id: string, json: EvidenceDataJson): Promise<any> {
  if (!json.data) {
    return null;
  }
  if (json.data.evidencemeta) {
    const query = json.data.evidencemeta.queries.find(query => query.id === id);
    if (query) {
      return {
        query,
        data: json.data[id],
      };
    }
  }
  return null;
}

async function getTemplate (id: string, root: string) {
  try {
    const fn = path.join(root, 'api-vis', `${id}.json`);
    const json = JSON.parse(await fsp.readFile(fn, { encoding: 'utf-8' }));

    if (!json.$$seriesField) {
      return data => ({
        ...json,
        dataset: {
          source: data,
        },
      });
    } else {
      const sf = json.$$seriesField;
      delete json.$$seriesField;
      return data => {
        const seriesValues = Array.from(new Set(data.map(item => item[sf])));
        return {
          ...json,
          series: seriesValues.map(s => ({
            ...json.series,
            datasetId: s,
            name: s,
          })),
          dataset: seriesValues.map(s => ({
            id: s,
            source: data.filter(item => item[sf] === s),
          })),
        };
      };
    }
  } catch {
    return null;
  }
}

export default handler;
