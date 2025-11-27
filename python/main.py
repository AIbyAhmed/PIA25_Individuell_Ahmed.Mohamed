"""
Simple demo script that runs a few queries and prints results.
Before running: ensure environment variables are set and schema + testdata exist.
"""

from queries import (
    get_all_products,
    get_products_by_brand,
    get_customer_orders,
    get_customer_spending,
)


def print_products(products):
    """Print a list of product dicts in a readable format."""
    if not products:
        print("Inga produkter hittades.")
        return
    for p in products:
        print(
            f"ID: {p.get('id','')} | Namn: {p.get('name',''):<25} | "
            f"Pris: {p.get('price','')} kr | Märke: {p.get('brand_name','')}"
        )


def print_orders(orders):
    """Print a list of order dicts in a readable format."""
    if not orders:
        print("Inga ordrar hittades.")
        return
    for o in orders:
        print(
            f"Order-ID: {o.get('id','')} | Datum: {o.get('order_date','')} | "
            f"Totalt: {o.get('total_amount','')} kr | Status: {o.get('status','')}"
        )


def main():
    """Run a few example queries and show the results."""
    print("=== Alla produkter ===")
    products = get_all_products()
    print_products(products)

    nordic_brands = ["Ericsson", "Bang & Olufsen", "Nokia", "Icelandic Tech", "Telia"]
    for brand in nordic_brands:
        print(f"\n=== Produkter från {brand} ===")
        products = get_products_by_brand(brand)
        print_products(products)

    customer_id = 1
    print(f"\n=== Ordrar för kund med ID {customer_id} ===")
    orders = get_customer_orders(customer_id)
    print_orders(orders)

    print(f"\n=== Total spending för kund {customer_id} ===")
    spending = get_customer_spending(customer_id)
    print(f"Total spenderat: {spending.get('total_spent', 0)} kr")


if __name__ == "__main__":
    main()
    
