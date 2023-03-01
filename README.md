## Oh My GitHub

`Oh My GitHub` (oh-my-github), which is a tool that utilizes GitHub Action and GitHub GraphQL API to synchronize GitHub data to a database. The tool can synchronize various content, including starred repositories, pull requests, issues, followers, followings, and created repositories. Moreover, it enables users to query and aggregate the synchronized data, generate beautiful charts, and discover stories behind the data using markdown and SQL.

## How to use

The repo requires the following environment variables to be set:

* `ACCESS_TOKEN`: A personal access token provided by GitHub, which can be set at https://github.com/settings/tokens.
* `USER_LOGIN`: The user login of the account you want to synchronize, which is typically set to your own GitHub account's user login. You can also set the user login of other users you want to synchronize, but note that you won't be able to synchronize private repositories and author_association information.
* `DATABASE_URL`: The MySQL connection information in URI format for TiDB Cloud. You need to register and create a serverless cluster on https://tidb.cloud, and the URI format should contain the necessary information for connecting to the cluster. An example of the DATABASE_URL format is: 

```
mysql2://xxx.root:password@hostxx.tidbcloud.com:4000/db_name
```

## How it works

![image](static/how_it_works.png)

## SVG api

>
