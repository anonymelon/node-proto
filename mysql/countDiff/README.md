# Setup

`npm install`
`npm install coffee-script -g`

# How To Run:

`coffee insertData.coffee`

# Config:

`config.coffee`


# Count SQL:

```sql
select id from origin o where o.id not in (select id from compare c) union all select count(id) from compare c where c.id not in (select id from origin);
```
This SQL maybe not a good solution, but works.
