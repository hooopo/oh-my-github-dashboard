


# Followers Analysis

### Summary

```current_user
select * from curr_user limit 1;
```

```followers_avg_followers_count
select avg(u.followers_count) as avg_followers
from users u join followers on u.id = followers.target_user_id
join curr_user on followers.user_id = curr_user.id
```

```followers_avg_registered_days

select avg(DATEDIFF(now(), u.created_at)) as avg_registered_days
from users u join followers on u.id = followers.target_user_id
join curr_user on followers.user_id = curr_user.id
```


<BigValue 
    data={current_user} 
    value='followers_count' 
    maxWidth='10em'
/> 

<BigValue 
    data={followers_avg_followers_count}
    value='avg_followers' 
    maxWidth='10em'
/> 

<BigValue 
    data={followers_avg_registered_days}
    value='avg_registered_days' 
    maxWidth='10em'
/> 

### Followers top regions

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

```followers_top_companies
select u.company,
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

