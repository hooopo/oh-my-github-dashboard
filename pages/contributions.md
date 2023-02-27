

## Contributions Overview

### Events per Month

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

### Events Running Total

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

### Code changes Running Total

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