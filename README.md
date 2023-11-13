# publishing-dbt
## What is _dbt?
_dbt is an open-source platform that allows you to manage models inside your data warehouse with the least effort. The main things you'll see in this project are yaml files, sql and jinja code. If you're hearing about this for the first time, no worries, however better to read some additional resources about those terms before starting to develop things in the project.
- [jinja](https://jinja.palletsprojects.com/en/3.1.x/templates/) - this is a short induction on how to use jinja, this will help you to understand how you can better automate your sql code.
- [sql](https://dataschool.com/books/) - this is a really good set of web books to improve your sql skills.
- [yaml](https://yaml.org/spec/1.2.2/) - a quick intro to what yaml is.
- [_dbt courses for beginners](https://courses.getdbt.com/collections/courses) - if this is the first time you hear about _dbt, this is a set of courses that can be treated as obligatory.
- [_dbt docs](https://docs.getdbt.com/docs/introduction) - documentation is very good and highly recommended to have at least a quick scan before starting with the project.
- [github](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) - if you're completely new to the git concept, read this to set up the project locally. Recommendation to use VS Code as your IDE of choice.
  
## How to run dbt pipeline?
Make sure you are in the directory with ```dbt_project.yml``` file ([publishing-dbt](https://github.com/hantypen/publishing-dbt/tree/main)).
Run [general setup](https://docs.getdbt.com/docs/core/installation) for dbt packages:<br>
```
pip install dbt-redshift
dbt deps
```
Run ```dbt debug --config-dir``` command and open profiles.yml file. Add data warehouse credentials:<br>
```
dbt_remote:
  outputs:
    dev:
      dbname: prod
      host: <add your host>
      password: <add password>
      port: 5439
      schema: public
      threads: 4
      type: redshift
      user: <add user>
      sslmode: prefer
  target: prod
```
Once all set, run models via dbt commands.
For example:
```
dbt run -s +fact_apointment_schedule runs all models that fact_apointment_schedule depends on
dbt test -s fact_apointment_schedule runs tests on fact_apointment_schedule
dbt build -s fact_apointment_schedule runs model and test via one command
dbt source freshness runs data freshness checks
```
Currently, the project has only 1 public model ```fact_apointment_schedule``` that could be found in models folder. ```yml``` file contains documentation on specifics.<br>
Terminal output should look like this:<br>
![](https://cdn.zappy.app/ba8ef0a3eb0ee2dfe99e1d334eb3016b.png)
