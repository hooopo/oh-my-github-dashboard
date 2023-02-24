# Repository Dashboard Reshape


## Basic Info

```info
select 'Full Name' as name,  concat(owner, '/', name) as value from repos
union
select 'Description' as name,  description as value from repos
union
select 'License' as name, license as value from repos
union
select 'Language' as name, language as value from repos
union
select 'Fork Count' as name, fork_count as value from repos
union
select 'Stargazer Count' as name, stargazer_count as value from repos
union
select 'Issue Count' as name, count(*) as value from issues 
union 
select 'Pull Request Count' as name, count(*) as value from pull_requests
union
select 'Contributors' as name, count(distinct author) as value from pull_requests
```

<DataTable
    data={info} 
    rows=20
    rowNumbers=false
/>

## The running total of stars per month

```star_history
WITH monthly_stars AS (
  SELECT DATE_FORMAT(starred_at, '%Y-%m') AS month, COUNT(*) AS total_stars
  FROM stars
  GROUP BY month
)
SELECT month, total_stars AS month_stars, SUM(total_stars) OVER (ORDER BY month) AS total_stars
FROM monthly_stars
ORDER BY 1 ASC
```

<LineChart 
    data={star_history}  
    x=month 
    y=total_stars
/>

## Top contributors analysis

```top_contributors
select author, 
  count(*) as pr_cnt, 
  concat('https://github.com/', author, '.png?size=50') as avatar,
  concat('https://github.com/', author) as author_url,
  sum(changed_files) as total_changed_files_num0k,
  sum(additions) as total_additions_num0k,
  sum(deletions) as total_deletions_num0k
from pull_requests 
where author not regexp 'bot' 
group by 1 
order by 2 desc 
limit 100;
```

<DataTable search=true data={top_contributors}>
    <Column id=avatar contentType=image height=30px align=center />
    <Column id=author_url contentType=link linkLabel=author />
    <Column id=pr_cnt align=left />
    <Column id=total_changed_files_num0k />
    <Column id=total_additions_num0k />
    <Column id=total_deletions_num0k />
</DataTable>

## Repository Contributor Analysis

* `COLLABORATOR`: Author has been invited to collaborate on the repository.
* `CONTRIBUTOR`: Author has previously committed to the repository.
* `FIRST_TIMER`: Author has not previously committed to GitHub.
* `FIRST_TIME_CONTRIBUTOR`: Author has not previously committed to the repository.
* `MANNEQUIN`: Author is a placeholder for an unclaimed user.
* `MEMBER`: Author is a member of the organization that owns the repository.
* `NONE`: Author has no association with the repository.
* `OWNER`: Author is the owner of the repository.

### Pull Request

```contributors_per_type
select author_association, date_format(created_at, '%Y-%m-01') as month, count(distinct author) as users_cnt from pull_requests group by 1, 2 ;
```

<AreaChart 
    data={contributors_per_type}  
    x=month 
    y=users_cnt
    series=author_association
/>

### Issue

```contributors_per_type_issue
select author_association, 
  date_format(created_at, '%Y-%m-01') as month, 
  count(distinct author) as users_cnt 
from issues 
group by 1, 2 ;
```

<AreaChart 
    data={contributors_per_type_issue}  
    x=month 
    y=users_cnt
    series=author_association
/>



## Stars per month

```stars_per_month

  SELECT DATE_FORMAT(starred_at, '%Y-%m') AS month, COUNT(*) AS total_stars
  FROM stars
  GROUP BY month
  ORDER BY 1 ASC;

```

<AreaChart 
    data={stars_per_month}  
    x=month 
    y=total_stars
/>

## Geographic distribution of stargazers

```star_region
SELECT region AS name, COUNT(*) AS value
FROM stars
WHERE region IS NOT NULL AND region != 'N/A'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c}'
        },
      series: [
        {
          type: 'treemap',
          visibleMin: 400,
          label: {
            show: true,
            formatter: '{b}'
          },
          itemStyle: {
            borderColor: '#fff'
          },
          roam: false,
          nodeClick: false,
          data: star_region,
          breadcrumb: {
            show: false
          }
        }
      ]
      }
    }
/>


## Company information about Stargazers

```star_company
select REPLACE(LOWER(company), '@', '') as company, count(*) as users_cnt
from stars 
where company is not null and company <> 'none'
group by 1 
order by 2 desc 
limit 15;
```

<BarChart 
    data={star_company} 
    x=company 
    y=users_cnt 
/>

## Code change analysis

```code_changes
select date_format(created_at, '%Y-%m-01') as month,  
  sum(additions ) as total_additions, 
  sum(deletions) as total_deletions
from pull_requests 
group by 1 
order by 1 asc;
```

<AreaChart 
    data={code_changes}  
    x=month 
    y={["total_additions", "total_deletions"]}
/>