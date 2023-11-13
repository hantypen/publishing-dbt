# publishing-dbt
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
