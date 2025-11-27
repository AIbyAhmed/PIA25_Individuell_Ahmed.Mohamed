"""
Helper for PostgreSQL connections. Reads PGUSER, PGPASSWORD, PGHOST, PGPORT, PGDATABASE from env.

Provides:
- get_engine() — SQLAlchemy Engine
- get_session() — SQLAlchemy Session
- session_scope() — transactional context manager
- get_connection() — raw DBAPI connection context manager

Notes: keep credentials out of source; uses SQLAlchemy for pooling.
"""

import os
from contextlib import contextmanager
from typing import Generator

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine, Connection
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.exc import SQLAlchemyError

# Load environment variables from .env
load_dotenv()

DB_USER = os.environ.get("PGUSER", "postgres")
DB_PASSWORD = os.environ.get("PGPASSWORD", "")
DB_HOST = os.environ.get("PGHOST", "localhost")
DB_PORT = os.environ.get("PGPORT", "5432")
DB_NAME = os.environ.get("PGDATABASE", "electronics_db")

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

_engine: Engine = create_engine(DATABASE_URL, pool_pre_ping=True)
_SessionFactory = sessionmaker(bind=_engine)


def get_engine() -> Engine:
    """Return the shared SQLAlchemy Engine instance."""
    return _engine


def get_session() -> Session:
    """Return a new SQLAlchemy Session. Prefer using session_scope()."""
    return _SessionFactory()


@contextmanager
def session_scope() -> Generator[Session, None, None]:
    """
    Simple transactional scope for DB work.
    Commits on success, rolls back on error, and always closes the session.
    """
    session = get_session()
    try:
        yield session
        session.commit()
    except SQLAlchemyError:
        session.rollback()
        raise
    finally:
        session.close()


@contextmanager
def get_connection() -> Generator[Connection, None, None]:
    """
    Give a raw DBAPI connection from the engine.
    Use this for plain SQL or cursor-level operations.
    """
    conn = _engine.connect()
    try:
        yield conn
    finally:
        conn.close()
        