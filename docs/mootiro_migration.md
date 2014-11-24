## migrating from mootiro

- run Intermediate redis (set a really long pass)
- set on the server the following env vars:

```
export REDIS_HOST=host
export REDIS_PORT=6379
export REDIS_PASS=really long redis server password
```

- run django shell

```
from migrate.tasks import migrate_all

migrate_all()
```

- on the Meppit server set these env vars

```
export MOOTIRO_REDIS_HOST=host
export MOOTIRO_REDIS_PORT=6379
export MOOTIRO_REDIS_PASS=really long redis server password
```

- copy all media files from Mootiro `media/upload` folder to Meppit `public/mootiro_media`

- run the task

```
rake mootiro_import
```

WARN: sometimes the connection with redis dies, If that happens just run again the task, and it will resume
      from where it stoped
