```current_user
select * from curr_user limit 1;
```

# Oh My GitHub for {current_user[0].login}

## Overview

```contribution_count
with events as (
  select id, user_id, created_at from issues
  union all
  select id, user_id, created_at from pull_requests
  union all
  select id, user_id, created_at from issue_comments
  union all
  select id, user_id, created_at from commit_comments
)

select count(*) as contribution_count
from events join curr_user on events.user_id = curr_user.id
```

```earned_stars
select sum(stargazer_count) as earned_stars
from repos join curr_user on repos.user_id = curr_user.id
where repos.is_fork = false and repos.is_private = false
```

```contributed_repos
with events as (
  select id, user_id, repo_id from issues
  union all
  select id, user_id, repo_id from pull_requests
  union all
  select id, user_id, repo_id from issue_comments
  union all
  select id, user_id, repo_id from commit_comments
)

select count(distinct repo_id) as contributed_repos from events join curr_user on events.user_id = curr_user.id
```

```code_additions
select sum(additions) as code_additions
from pull_requests join curr_user on pull_requests.user_id = curr_user.id
```

```code_deletions
select sum(deletions) as code_deletions
from pull_requests join curr_user on pull_requests.user_id = curr_user.id
```

<BigValue
    data={contribution_count}
    value=contribution_count
    maxWidth='10em'
/>

<BigValue
    data={current_user}
    value='followers_count'
    maxWidth='10em'
/>

<BigValue
    data={earned_stars}
    value=earned_stars
    maxWidth='10em'
/>

<BigValue
    data={contributed_repos}
    value=contributed_repos
    maxWidth='10em'
/>

<BigValue
    data={code_additions}
    value=code_additions
    maxWidth='10em'
/>

<BigValue
    data={code_deletions}
    value=code_deletions
    maxWidth='10em'
/>

## Contributions Analysis

### Events per Month

The Contributions Analysis report for OSS (Open Source Software) contribution provides a detailed analysis of an individual's contributions to an all repositories. The report includes data on various types of events such as issue events, pull requests, commit comments, and issue comments, all grouped by the contributor who made the contributions. The report visualizes the data in a single chart, making it easy to track an individual's contributions over time.


```contributions_per_month
with events as (
  select id, user_id, created_at, 'issue' as type from issues
  union all
  select id, user_id, created_at, 'pull_request' as type from pull_requests
  union all
  select id, user_id, created_at, 'issue_comment' as type from issue_comments
  union all
  select id, user_id, created_at, 'commit_comment' as type from commit_comments
)

select date_format(events.created_at, '%Y-%m-01') as month, type, count(*) as cnt
from events join curr_user on events.user_id = curr_user.id
group by 1, 2
order by 1 asc
```

<AreaChart 
    data={contributions_per_month}  
    x=month 
    y=cnt
    series=type
/>


### Code Changes per Month

The Code Changes per Month report is a valuable analytics tool that provides a comprehensive view of a user's code development on GitHub over time. 

```contributions_code_changes
select date_format(pr.created_at, '%Y-%m-01') as month,  
  sum(pr.additions ) as total_additions, 
  sum(pr.deletions) as total_deletions
from pull_requests pr join curr_user on pr.user_id = curr_user.id
group by 1
order by 1 asc;
```

<AreaChart 
    data={contributions_code_changes}  
    x=month 
    y={["total_additions", "total_deletions"]}
/>

### Events history

The Contributions Running Total report is a valuable analytics tool that provides a cumulative view of a user's contributions on GitHub over time. 

```contributions_running_total
with events as (
  select id, user_id, created_at from issues
  union all
  select id, user_id, created_at from pull_requests
  union all
  select id, user_id, created_at from issue_comments
  union all
  select id, user_id, created_at from commit_comments
),
monthly_events as (
  select date_format(events.created_at, '%Y-%m-01') as month, count(*) as cnt
  from events join curr_user on events.user_id = curr_user.id
  group by 1
  order by 1 asc
)

select month, sum(cnt) over (order by month) as total
from monthly_events
order by 1 asc
```

<AreaChart 
    data={contributions_running_total}  
    x=month 
    y=total
/>

### Code changes history

The Code Changes History report is a valuable analytics tool that provides a detailed history of the changes made to a user's code on GitHub. The report includes data on the number of code changes made by the user over time, as well as the specific changes made to each file, making it easy to identify trends and patterns in the user's code development.

```contributions_code_changes_running_total
with monthly_events as (
  select date_format(pr.created_at, '%Y-%m-01') as month,  
    sum(pr.additions ) as total_additions, 
    sum(pr.deletions) as total_deletions
  from pull_requests pr join curr_user on pr.user_id = curr_user.id
  group by 1
  order by 1 asc
)

select month, sum(total_additions) over(order by month) as total_additions , sum(total_deletions)  over (order by month) as total_deletions
from monthly_events
order by 1 asc
```

<AreaChart 
    data={contributions_code_changes_running_total}  
    x=month 
    y={["total_additions", "total_deletions"]}  
/>


### Most contributed to repositories

The Most Contributed to Repositories List report is a valuable analytics tool that provides a list of the repositories where a user has made the most contributions on GitHub. The report includes data on the number of contributions made by the user to each repository, making it easy to identify the repositories where the user has been most active.

```contributions_repos
with events as (
  select id, user_id, repo_id, created_at, 'issue' as type from issues
  union all
  select id, user_id, repo_id, created_at, 'pull_request' as type from pull_requests
  union all
  select id, user_id, repo_id, created_at, 'issue_comment' as type from issue_comments
  union all
  select id, user_id, repo_id, created_at, 'commit_comment' as type from commit_comments
)

select concat(repos.owner, "/", repos.name) as repo_name, count(*) as cnt
from events e
join curr_user on e.user_id = curr_user.id
join repos on e.repo_id = repos.id
group by 1
order by 2 desc
limit 10;
```

<BarChart 
    data={contributions_repos} 
    x=repo_name
    y=cnt
    swapXY=true
/>



### Author Association

* `COLLABORATOR`: Author has been invited to collaborate on the repository.
* `CONTRIBUTOR`: Author has previously committed to the repository.
* `FIRST_TIMER`: Author has not previously committed to GitHub.
* `FIRST_TIME_CONTRIBUTOR`: Author has not previously committed to the repository.
* `MANNEQUIN`: Author is a placeholder for an unclaimed user.
* `MEMBER`: Author is a member of the organization that owns the repository.
* `NONE`: Author has no association with the repository.
* `OWNER`: Author is the owner of the repository.

```contributions_author_association_pie
select author_association as name, count(*) as value  
from pull_requests pr join curr_user on pr.user_id = curr_user.id
group by 1
order by 2 desc
```

<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
        {
          type: 'pie',
          radius: ['40%', '70%'],
          data: contributions_author_association_pie,
        }
      ]
      }
    }
/>

### Contributions Types

The Contributions Types Pie report is a valuable analytics tool that provides a breakdown of a user's contributions on GitHub by the type of contribution. The report includes data on the number of issues, pull requests, comments, and other contributions made by the user, making it easy to identify the types of contributions in which the user is most active.



```contributions_type_pie
select type as name, count(*) as value
from (
  select user_id, 'issue' as type from issues
  union all
  select user_id, 'pull_request' as type from pull_requests
  union all
  select user_id, 'issue_comment' as type from issue_comments
  union all
  select user_id, 'commit_comment' as type from commit_comments
) t
join curr_user on t.user_id = curr_user.id
group by 1
order by 2 desc
```

<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
        {
          type: 'pie',
          radius: ['40%', '70%'],
          data: contributions_type_pie,
        }
      ]
      }
    }
/>

## Followers Analysis

### Followers top regions

The Followers Top Regions report is a valuable tool for users looking to engage with their community and identify potential collaborators and advocates in specific regions. By analyzing the data, users can gain valuable insights into the geographic distribution of their follower base and make data-driven decisions to improve the quality of their work and engage more effectively with their community.

```followers_top_regions
select u.region as name,
        count(*) as value
from users u join followers on u.id = followers.target_user_id
join curr_user on followers.user_id = curr_user.id
where u.region is not null and u.region != '' and u.region != 'N/A'
group by 1
order by 2 desc 
limit 5
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
          data: followers_top_regions,
          breadcrumb: {
            show: false
          }
        }
      ]
      }
    }
/>

### Top Companies of Followers

The Top Companies of Followers report is a valuable analytics tool that provides a list of the most common companies among a user's followers on GitHub. The report includes data on the number of followers affiliated with each company, making it easy to identify the companies with the most engaged followers.

```followers_top_companies
select lower(replace(u.company, "@", "")) as company,
        count(*) as count
from users u join followers on u.id = followers.target_user_id
join curr_user on followers.user_id = curr_user.id
where u.company is not null and u.company != '' and u.company != 'N/A'
group by 1
order by 2 desc
limit 10
```

<BarChart 
    data={followers_top_companies} 
    x='company' 
    y='count'
    title='Top Companies of Followers'
/>

### Followers Registered Years

The Followers Registered Years report is a valuable analytics tool that provides a breakdown of a user's followers by the year they registered on GitHub. The report includes data on the number of followers registered in each year, making it easy to identify trends in the user's follower base.

```followers_registered_years
select datediff(now(), u.created_at) DIV 365  as years,
        count(*) as count
from users u join followers on u.id = followers.target_user_id
join curr_user on followers.user_id = curr_user.id
group by 1
order by 1 asc 
```

<BarChart 
    data={followers_registered_years} 
    x='years' 
    y='count'
    title='Registered Years of Followers'  
/>


### Top Followers by Followers Count

The Top Followers by Followers Count report for a user is a valuable analytics tool that provides a list of the most followed users of a specific GitHub user. The report includes data on the number of followers for each user, making it easy to identify the most influential and engaged followers of a user.

```top_followers_by_followers_count
select u.login,
       u.followers_count,
       concat('https://github.com/', u.login, '.png?size=50') as avatar,
       concat('https://github.com/', u.login) as login_url,
       u.following_count,
       u.twitter_username
from users u join followers on u.id = followers.target_user_id
join curr_user on followers.user_id = curr_user.id
order by 2 desc
limit 100
```

<DataTable search=true data={top_followers_by_followers_count}>
    <Column id=avatar contentType=image height=30px align=center />
    <Column id=login_url contentType=link linkLabel=login />
    <Column id=followers_count />
    <Column id=following_count />
    <Column id=twitter_username />
</DataTable>


## Deploy your own Dashboard

[![Deploy your own Dashboard](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fhooopo%2Foh-my-github-dashboard&env=MYSQL_DATABASE&envDescription=name%20for%20your%20database&integration-ids=oac_coKBVWCXNjJnCEth1zzKoF1j)

[More info here](https://github.com/hooopo/oh-my-github-dashboard#oh-my-github-dashboard)


