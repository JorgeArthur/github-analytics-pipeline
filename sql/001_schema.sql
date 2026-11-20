CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
CREATE SCHEMA IF NOT EXISTS ops;


CREATE TABLE IF NOT EXISTS bronze.api_responses (
    id BIGSERIAL PRIMARY KEY,
    repo TEXT NOT NULL,
    endpoint TEXT NOT NULL,
    fetched_at TIMESTAMPTZ NOT NULL,
    http_status INT NOT NULL,
    page_url TEXT NOT NULL,
    payload JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS silver.repositories (
    repo_id BIGINT PRIMARY KEY,
    full_name TEXT NOT NULL UNIQUE,
    owner_login TEXT NOT NULL,
    description TEXT NOT NULL,
    language text NOT NULL,
    isfork  boolean NOT NULL,
    is_archived boolean NOT NULL,
    stars_count INT NOT NULL,
    forks_count INT NOT NULL,
    open_issues_count INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,
    pushed_at TIMESTAMPTZ NOT NULL,
    loaded_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.issues (
    issue_id BIGINT PRIMARY KEY,
    repo_id BIGINT NOT NULL REFERENCES silver.repositories(repo_id),
    issue_number INT NOT NULL,
    title TEXT NOT NULL,
    state TEXT NOT NULL,
    author_login TEXT NOT NULL,
    is_pull_request BOOLEAN NOT NULL DEFAULT FALSE,
    labels JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,
    closed_at TIMESTAMPTZ,
    html_url TEXT NOT NULL,
    loaded_at TIMESTAMPTZ NOT NULL,
    UNIQUE (repo_id, issue_number)
);

CREATE TABLE IF NOT EXISTS silver.commits (
    sha TEXT PRIMARY KEY,
    repo_id BIGINT NOT NULL REFERENCES silver.repositories(repo_id),
    message TEXT NOT NULL,
    author_login TEXT NOT NULL,
    author_name TEXT NOT NULL,
    author_email TEXT NOT NULL,
    authored_at TIMESTAMPTZ NOT NULL,
    commited_at TIMESTAMPTZ NOT NULL,
    html_url TEXT NOT NULL,
    loaded_at TIMESTAMPTZ NOT NULL
);
