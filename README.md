## Oh My GitHub

## GitHub Data Sync

This repository provides a data pipeline that syncs GitHub repositories with a free MySQL-compatible cloud database, TiDB Cloud. It can be used as a standalone data pipeline or as a personal dashboard.

### Standalone Data Pipeline

To use this repository as a standalone data pipeline, simply set the environment variables and the GitHub action will run automatically every hour. This will sync the specified user's GitHub data to TiDB Cloud.

![image](https://user-images.githubusercontent.com/63877/226034715-edf3ea0f-870f-4933-8f6c-ea28a56dad1b.png)

Environment Secrets

To use this repository, you will need to set the following secrets on GitHub:

* `ACCESS_TOKEN`: A personal access token provided by GitHub, which can be obtained from [Sign in to GitHub · GitHub](https://github.com/settings/tokens).
* `USER_LOGIN`: Optional, default is your access_token related user. The user login of the account you want to sync. This can be your own GitHub account's user login or the user login of other users you want to sync. Note that if you choose to sync other users, you won't be able to sync private repositories and author_association information.
* `DATABASE_URL`: The MySQL connection information in URI format for TiDB Cloud. You will need to register and create a serverless cluster on [https://tidb.cloud](https://tidb.cloud/), and the URI format should contain the necessary information for connecting to the cluster. An example of the DATABASE_URL format is: mysql2://xxx.root:password@hostxx.tidbcloud.com:4000/db_name

⚠️ Make sure you enable GitHub Action for this forked repo.

![image](https://user-images.githubusercontent.com/63877/226040673-bf5467ee-d8c7-4380-a705-0504229ddf16.png)


### Personal Dashboard

If you only intend to use this repository as a data pipeline, you can ignore the following content.

To use this repository as a personal dashboard, after setting up the data pipeline, you can create a web application that queries the MySQL database and displays the data in a user-friendly format.

![image](https://user-images.githubusercontent.com/63877/226038417-89937699-8cbb-49f1-8b0f-992db6bc2f26.png)


One option for creating a personal dashboard is to use Evidence (SSG) to display the dashboard on Vercel. You can read the data from TiDB Cloud and build the dashboard every hour.

Using the synced data, you can analyze your GitHub activity and use it for personal branding or as a resume. This repository provides a flexible and powerful solution for syncing and analyzing your GitHub data, whether you use it as a personal dashboard or a standalone data pipeline.


## How it works

![image](static/how_it_works.png)

## SVG api

[svg api](api/svg/[id].ts) will automatically find data from evidence build files. This api uses echarts templates from [api-vis](api-vis).

The final url would be YOUR_VERCEL_DOMAIN/api/svg/CHART_ID?w=480&h=320.

The CHART_ID is the query id from any pages, default width is 640 and default height is 320.

### Customize & Development

```
npm run dev:api
```

> This command will only build evidence pages once, so you **could not** change the SQL after started.

- Add more templates in [api-vis](api-vis) dir, the filename must be the CHART_ID currently. (You must add queries first and restart the dev:api command)
- Edit [\[id\].ts](api/svg/[id].ts) and support more types of charts.
