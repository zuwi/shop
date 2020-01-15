JWTSessions.encryption_key = 'secret'
JWTSessions.token_store = :redis, {
    redis_host: "redis://0.0.0.0",
    redis_port: "6379",
    redis_db_name: "1",
    token_prefix: "jwt_"
}