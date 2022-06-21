<img src=https://www.toriihq.com/hubfs/Torii_logo_new.svg>
# Welcome to your Torii Data Warehouse dbt project!

## Project installation

1. follow macOS instructions to set up the following on your macOS environment. 
   1. xcode, homebrew, iTerm2+zsh, git, bash completion (https://sourabhbajaj.com/mac-setup/)
   2. for python: pip & virtualenv follow: https://docs.python-guide.org/dev/virtualenvs/
   3. for text editor i recommend Atom (https://atom.io/) 
2. create local folder for the project
3. follow https://docs.getdbt.com/dbt-cli/install/pip for installation of dbt-cli
4. make sure to work under virtual environment in order to isolate the python environment for the project.
   1. follow (https://docs.python-guide.org/dev/virtualenvs/) for setting the virtual environment.
   2. once done and in the project folder run freeze for creating the requirements.txt
   3. also recommended, add the source to your .zshrc  for aliasing the virtual environment instead of
      running each time the source for it.
      example: `alias env_dbt = source /Users/{user}/projects/torii_dwh_dbt/venv/bin/activate`
      after running `env_dbt` you should see the virtual environment enabled on your zsh prompt
5. install local dbt cli we use snowflake adapter: `pip install dbt-snowflake`
6. create (for a new project) / clone the remote git repository (https://github.com/toriihq/torii_dwh_dbt.git)
7. test installation: `dbt --version`

## Using the starter project

Try running the following commands:
- dbt run
- dbt test

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## Torii Data Warehouse knowledge base

- Architecture: https://www.notion.so/toriihq/Data-Warehouse-Architecture-257e9f243df74f3796c6946094e2e7d5
- Make sure to follow naming convention: https://www.notion.so/toriihq/Naming-Convention-6488a4a7ebed448f9d31e21a3cac2591
- Torii's DataWarehouse is following DataVault methodologies (https://danlinstedt.com/solutions-2/data-vault-basics/)

## dbt Packages included

- dbtVault: https://dbtvault.readthedocs.io/en/latest/