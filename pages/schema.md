
## User
```users
desc users
```

<DataTable
    data={users} 
    rows=20
    rowNumbers=false
/>

```user_sample
select * from users order by id asc limit 10;
```

<DataTable
    data={user_sample} 
    rows=20
    rowNumbers=false
/>

## Repo

```repos
desc repos
```

<DataTable
    data={repos} 
    rows=20
    rowNumbers=false
/>

```repo_sample
select * from repos order by id desc limit 10;
```

<DataTable
    data={repo_sample} 
    rows=20
    rowNumbers=false
/>

## Pull Request
```pull_requests
desc pull_requests
```

<DataTable
    data={pull_requests} 
    rows=20
    rowNumbers=false
/>

```pull_request_sample
select * from pull_requests order by id desc limit 10;
```

<DataTable
    data={pull_request_sample} 
    rows=20
    rowNumbers=false
/>

## Issue
```issues
desc issues
```

<DataTable
    data={issues} 
    rows=20
    rowNumbers=false
/>


```issue_sample
select * from issues order by id desc limit 10;
```

<DataTable
    data={issue_sample} 
    rows=20
    rowNumbers=false
/>

## Followings
```followings
desc followings
```

<DataTable
    data={followings} 
    rows=20
    rowNumbers=false
/>

```following_sample
select * from followings limit 10;
```

<DataTable
    data={following_sample} 
    rows=20
    rowNumbers=false
/>

## Followers
```followers
desc followers
```

<DataTable
    data={followers}
    rows=20
    rowNumbers=false
/>

```follower_sample
select * from followings limit 10;
```

<DataTable
    data={follower_sample} 
    rows=20
    rowNumbers=false
/>

## Issue comments
```issue_comments
desc issue_comments
```

<DataTable
    data={issue_comments}
    rows=20
    rowNumbers=false
/>

```issue_comment_sample
select * from issue_comments limit 10;
```

<DataTable
    data={issue_comment_sample} 
    rows=20
    rowNumbers=false
/>

## Commit comments
```commit_comments
desc commit_comments
```

<DataTable
    data={commit_comments}
    rows=20
    rowNumbers=false
/>

```commit_comment_sample
select * from commit_comments limit 10;
```

<DataTable
    data={commit_comment_sample} 
    rows=20
    rowNumbers=false
/>

## Starred Repo
```starred_repos
desc starred_repos
```

<DataTable
    data={starred_repos}
    rows=20
    rowNumbers=false
/>

```starred_repo_sample
select * from starred_repos limit 10;
```

<DataTable
    data={starred_repo_sample} 
    rows=20
    rowNumbers=false
/>