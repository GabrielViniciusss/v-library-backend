# Deploy to Render (free tier friendly)

This project ships with a Dockerfile. Render can build and run it directly.

## 1) Create a Postgres database (Neon)

- Go to https://neon.tech/ and create a free project
- Copy the connection string (looks like `postgresql://...`)

## 2) Create a Render Web Service

- Go to https://dashboard.render.com/
- New + → Web Service → Connect your GitHub repo (v-library-backend)
- Use the `render.yaml` in the repo (auto-detected) or choose “Use Docker”
- Select “Free” plan

## 3) Set environment variables

In the Render service settings → Environment → Add the following:

- `DATABASE_URL` = paste the connection string from Neon
- `SECRET_KEY_BASE` = a random secret (generate with `bundle exec rails secret`)
- `DEVISE_JWT_SECRET` = a random secret (generate with `bundle exec rails secret` locally)
- `RAILS_ENV` = `production`
- `RACK_ENV` = `production`

Notes:
- We do not require `RAILS_MASTER_KEY` because `SECRET_KEY_BASE` (and JWT) are read from env vars in production.
- CORS is already configured to allow `Authorization` header.

## 4) Deploy

- Click “Deploy” in Render. The Dockerfile will be built and the app started.
- On first boot, the container runs `rails db:prepare` automatically (via `bin/docker-entrypoint`).

## 5) Test

- Swagger UI: `https://<your-service>.onrender.com/api-docs`
- GraphQL endpoint: `POST https://<your-service>.onrender.com/graphql`

## Troubleshooting

- If you get `Blocked host` errors, ensure `config/environments/production.rb` includes `*.onrender.com` in `config.hosts` (already set).
- If DB migrations are missing, check logs and restart the service (db:prepare runs on boot).
- For background jobs, consider a separate worker service or keep them in the web dyno (Solid Queue can run in Puma).
