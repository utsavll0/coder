-- name: GetExternalAuthLink :one
SELECT * FROM external_auth_links WHERE provider_id = $1 AND user_id = $2;

-- name: DeleteExternalAuthLink :exec
DELETE FROM external_auth_links WHERE provider_id = $1 AND user_id = $2;

-- name: GetExternalAuthLinksByUserID :many
SELECT * FROM external_auth_links WHERE user_id = $1;

-- name: InsertExternalAuthLink :one
INSERT INTO external_auth_links (
    provider_id,
    user_id,
    created_at,
    updated_at,
    oauth_access_token,
    oauth_access_token_key_id,
    oauth_refresh_token,
    oauth_refresh_token_key_id,
    oauth_expiry,
	oauth_extra
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
	$10
) RETURNING *;

-- name: UpdateExternalAuthLink :one
UPDATE external_auth_links SET
    updated_at = $3,
    oauth_access_token = $4,
    oauth_access_token_key_id = $5,
    oauth_refresh_token = $6,
    oauth_refresh_token_key_id = $7,
    oauth_expiry = $8,
	oauth_extra = $9
WHERE provider_id = $1 AND user_id = $2 RETURNING *;

-- name: UpdateExternalAuthLinkRefreshToken :exec
UPDATE
	external_auth_links
SET
	oauth_refresh_token = @oauth_refresh_token,
	updated_at = @updated_at
WHERE
    provider_id = @provider_id
AND
    user_id = @user_id
AND
    -- Required for sqlc to generate a parameter for the oauth_refresh_token_key_id
    @oauth_refresh_token_key_id :: text = @oauth_refresh_token_key_id :: text;
