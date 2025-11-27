"""
Simple query functions that return lists of dicts.
Each function uses session_scope() so the DB session is closed automatically.
"""

from typing import List, Dict, Any
from sqlalchemy import text
from database import session_scope


def _rows_to_dicts(result) -> List[Dict[str, Any]]:
    """Turn a SQL result into a list of dictionaries (column -> value)."""
    keys = result.keys()
    return [dict(zip(keys, row)) for row in result.fetchall()]


def get_all_products() -> List[Dict[str, Any]]:
    """
    Return all products with their brand, category and price.
    Results are ordered by product name.
    """
    sql = """
        SELECT p.id, p.name, p.price, p.category, b.name AS brand_name
        FROM products p
        LEFT JOIN brands b ON p.brand_id = b.id
        ORDER BY p.name ASC;
    """
    with session_scope() as session:
        result = session.execute(text(sql))
        return _rows_to_dicts(result)


def get_products_by_brand(brand_name: str) -> List[Dict[str, Any]]:
    """
    Return products for the given brand name.
    Uses a parameter so it's safe from SQL injection.
    """
    sql = """
        SELECT p.id, p.name, p.price, p.category, b.name AS brand_name
        FROM products p
        JOIN brands b ON p.brand_id = b.id
        WHERE b.name = :brand_name
        ORDER BY p.name ASC;
    """
    with session_scope() as session:
        result = session.execute(text(sql), {"brand_name": brand_name})
        return _rows_to_dicts(result)


def get_customer_orders(customer_id: int) -> List[Dict[str, Any]]:
    """
    Return orders for a customer, newest first.
    Each row contains order id, date, total amount and status.
    """
    sql = """
        SELECT o.id, o.order_date, o.total_amount, o.status
        FROM orders o
        WHERE o.customer_id = :cid
        ORDER BY o.order_date DESC;
    """
    with session_scope() as session:
        result = session.execute(text(sql), {"cid": customer_id})
        return _rows_to_dicts(result)


def get_customer_spending(customer_id: int) -> Dict[str, Any]:
    """
    Calculate how much a customer has spent in total.
    Sums unit_price * quantity across the customer's orders.
    Returns a dict like {'total_spent': 1234.56}.
    """
    sql = """
        SELECT COALESCE(SUM(oi.unit_price * oi.quantity), 0) AS total_spent
        FROM orders o
        JOIN order_items oi ON oi.order_id = o.id
        WHERE o.customer_id = :cid;
    """
    with session_scope() as session:
        result = session.execute(text(sql), {"cid": customer_id})
        rows = _rows_to_dicts(result)
        return rows[0] if rows else {"total_spent": 0}