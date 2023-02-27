


```contributions_over_time
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
    data={contributions_over_time}  
    x=month 
    y=cnt
    series=type
/>

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