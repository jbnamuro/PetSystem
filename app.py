# app.py
from flask import Flask, render_template, request, redirect, url_for, session, flash
from config import get_db_connection

app = Flask(__name__)
app.secret_key = "PetSystemSecretKey"

def call_proc_fetchall(proc_name, args=()):
    db = get_db_connection()
    cursor = db.cursor()
    cursor.callproc(proc_name, args)
    try:
        results = cursor.fetchall()
    except Exception:
        results = []
    cursor.close()
    db.close()
    return results

def call_proc_no_result(proc_name, args=()):
    db = get_db_connection()
    cursor = db.cursor()
    cursor.callproc(proc_name, args)

    # Consume any result sets returned by the procedure
    while True:
        try:
            cursor.fetchall()
        except Exception:
            pass
        # advance to next result if present
        if not cursor.nextset():
            break

    db.commit()
    cursor.close()
    db.close()


# ----------------
# Authentication
# ----------------
@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"].strip()
        password = request.form["password"].strip()
        try:
            # validate_login returns user details via get_user_details
            rows = call_proc_fetchall('validate_login', (username, password))
            if not rows:
                flash("Invalid credentials.", "danger")
                return render_template("login.html")
            # get_user_details returns (UserID, Username, Role)
            user = rows[0]
            session["user_id"] = user[0]
            session["username"] = user[1]
            session["role"] = user[2]
            flash(f"Welcome, {session['username']}!", "success")
            return redirect(url_for("dashboard"))
        except Exception as e:
            flash(str(e), "danger")
            return render_template("login.html")
    return render_template("login.html")

@app.route("/logout")
def logout():
    session.clear()
    flash("Logged out.", "info")
    return redirect(url_for("login"))

# ----------------
# Dashboard
# ----------------
@app.route("/dashboard")
def dashboard():
    if "user_id" not in session:
        return redirect(url_for("login"))
    # Fetch a few featured/available pets to show on the dashboard
    try:
        pets = call_proc_fetchall('browse_pets', (5, 1, 'DateAdded', 'DESC', None, None, None, None, 'Available', None, None))
    except Exception:
        pets = []

    return render_template("dashboard.html", username=session.get("username"), role=session.get("role"), pets=pets)

# ----------------
# Pets (Admin/Staff CRUD)
# ----------------
@app.route("/pets", methods=["GET"])
def pets():
    if "user_id" not in session:
        return redirect(url_for("login"))
    # Use browse_pets with defaults to fetch all
    pets = call_proc_fetchall('browse_pets', (1000, 1, 'DateAdded', 'DESC', None, None, None, None, None, None, None))
    # browse_pets returns rows with many columns: map to what template expects
    # We'll pass raw rows and template will index into them
    return render_template("pets.html", pets=pets, role=session.get("role"))

@app.route("/add_pet", methods=["POST"])
def add_pet():
    if session.get("role") not in ("Admin", "Staff"):
        flash("Unauthorized", "danger")
        return redirect(url_for("pets"))
    try:
        user_id = session.get("user_id")
        p_pet_name = request.form.get("name")
        p_description = request.form.get("description", "")
        p_species_id = int(request.form.get("species"))
        p_rarity_id = int(request.form.get("rarity"))
        p_maintenance_id = int(request.form.get("maintenance"))
        p_price = float(request.form.get("price", 0.0))
        p_sprite_path = request.form.get("sprite", None)
        p_sound_path = request.form.get("sound", None)

        # Call stored procedure
        call_proc_no_result('add_pet', (
            user_id,
            p_pet_name,
            p_description,
            p_species_id,
            p_rarity_id,
            p_maintenance_id,
            p_price,
            p_sprite_path,
            p_sound_path
        ))
        flash("Pet added.", "success")
    except Exception as e:
        flash(f"Failed to add pet: {e}", "danger")
    return redirect(url_for("pets"))

@app.route("/update_pet/<int:pet_id>", methods=["POST"])
def update_pet(pet_id):
    if session.get("role") not in ("Admin", "Staff"):
        flash("Unauthorized", "danger")
        return redirect(url_for("pets"))
    try:
        user_id = session.get("user_id")
        # Fields nullable: pass None for unchanged fields (form empty)
        name = request.form.get("name") or None
        description = request.form.get("description") or None
        species = request.form.get("species")
        species = int(species) if species not in (None, "") else None
        rarity = request.form.get("rarity")
        rarity = int(rarity) if rarity not in (None, "") else None
        maintenance = request.form.get("maintenance")
        maintenance = int(maintenance) if maintenance not in (None, "") else None
        price = request.form.get("price")
        price = float(price) if price not in (None, "") else None
        sprite = request.form.get("sprite") or None
        sound = request.form.get("sound") or None
        status = request.form.get("status") or None

        call_proc_no_result('update_pet', (
            user_id, pet_id, name, description, species, rarity, maintenance, price, sprite, sound, status
        ))
        flash("Pet updated.", "info")
    except Exception as e:
        flash(f"Failed to update pet: {e}", "danger")
    return redirect(url_for("pets"))

@app.route("/delete_pet/<int:pet_id>", methods=["POST"])
def delete_pet(pet_id):
    if session.get("role") not in ("Admin", "Staff"):
        flash("Unauthorized", "danger")
        return redirect(url_for("pets"))
    try:
        user_id = session.get("user_id")
        call_proc_no_result('remove_pet', (user_id, pet_id))
        flash("Pet removed.", "info")
    except Exception as e:
        flash(f"Failed to remove pet: {e}", "danger")
    return redirect(url_for("pets"))

# ----------------
# View Pets (Users)
# ----------------
@app.route("/view_pets")
def view_pets():
    # For users: use browse_pets but filter to available
    pets = call_proc_fetchall('browse_pets', (1000, 1, 'DateAdded', 'DESC', None, None, None, None, 'Available', None, None))
    # browse_pets columns: PetID, PetName, SpeciesName, RarityName, MaintenanceName, Status, Price, DateAdded, SpritePath, SoundPath
    return render_template("view_pets.html", pets=pets)

# ----------------
# Cart endpoints
# ----------------
@app.route("/cart")
def cart():
    if "user_id" not in session:
        return redirect(url_for("login"))
    try:
        items = call_proc_fetchall('get_cart_details', (session["user_id"],))
        # Calculate subtotal from items. Price is expected at index 5 in each item row.
        try:
            subtotal = sum(float(it[5]) for it in items)
        except Exception:
            subtotal = 0.0
        # Tax and total
        tax_rate = 0.13
        tax = round(subtotal * tax_rate, 2)
        total = round(subtotal + tax, 2)
        return render_template("cart.html", items=items, subtotal=subtotal, tax=tax, total=total)
    except Exception as e:
        flash(f"Unable to load cart: {e}", "danger")
        return redirect(url_for("dashboard"))

@app.route("/cart/add/<int:pet_id>", methods=["POST"])
def add_to_cart(pet_id):
    if session.get("role") != "User":
        flash("Only customers can add to cart.", "danger")
        return redirect(url_for("view_pets"))
    try:
        call_proc_no_result('add_to_cart', (session["user_id"], pet_id))
        flash("Added to cart.", "success")
    except Exception as e:
        flash(f"Add to cart failed: {e}", "danger")
    return redirect(url_for("view_pets"))

@app.route("/cart/remove/<int:pet_id>", methods=["POST"])
def remove_from_cart(pet_id):
    if session.get("role") != "User":
        flash("Only customers can remove from cart.", "danger")
        return redirect(url_for("cart"))
    try:
        call_proc_no_result('remove_from_cart', (session["user_id"], pet_id))
        flash("Removed from cart.", "info")
    except Exception as e:
        flash(f"Remove from cart failed: {e}", "danger")
    return redirect(url_for("cart"))

@app.route("/checkout", methods=["POST"])
def checkout():
    if session.get("role") != "User":
        flash("Only customers can checkout.", "danger")
        return redirect(url_for("cart"))
    try:
        # checkout_cart will call get_order_details internally as part of its last step
        order_summary = call_proc_fetchall('checkout_cart', (session["user_id"],))
        flash("Checkout completed.", "success")
        # Render order details if returned
        return render_template("orders.html", orders=order_summary, role=session.get("role"))
    except Exception as e:
        flash(f"Checkout failed: {e}", "danger")
        return redirect(url_for("cart"))

# ----------------
# Orders (Admin/Staff view all; User view own)
# ----------------
@app.route("/orders")
def orders():
    if "user_id" not in session:
        return redirect(url_for("login"))
    try:
        if session.get("role") in ("Admin", "Staff"):
            # Admin view: fetch all orders with username
            db = get_db_connection()
            cursor = db.cursor()
            cursor.execute("""
                SELECT o.OrderID, u.Username, o.TotalPrice, o.OrderDate
                FROM orders o
                JOIN users u ON o.UserID = u.UserID
                ORDER BY o.OrderDate DESC
            """)
            orders = cursor.fetchall()
            cursor.close()
            db.close()
            return render_template("orders.html", orders=orders, role=session.get("role"))
        else:
            # User view: use get_user_orders
            orders = call_proc_fetchall('get_user_orders', (session.get("user_id"),))
            return render_template("orders.html", orders=orders, role=session.get("role"))
    except Exception as e:
        flash(f"Could not load orders: {e}", "danger")
        return redirect(url_for("dashboard"))

# ----------------
# Users (Admin only)
# ----------------
@app.route("/users")
def users():
    if session.get("role") != "Admin":
        flash("Unauthorized", "danger")
        return redirect(url_for("dashboard"))
    db = get_db_connection()
    cursor = db.cursor()
    cursor.execute("SELECT UserID, Username, Role FROM users ORDER BY UserID")
    users = cursor.fetchall()
    cursor.close()
    db.close()
    return render_template("users.html", users=users)

@app.route("/register_customer", methods=["POST"])
def register_customer():
    # public registration can be implemented; here admin can also create customers via stored proc
    username = request.form.get("username")
    password = request.form.get("password")
    try:
        call_proc_no_result('register_customer', (username, password))
        flash("Customer registered.", "success")
    except Exception as e:
        flash(f"Registration failed: {e}", "danger")
    return redirect(url_for("login"))

@app.route("/register_staff", methods=["POST"])
def register_staff():
    if session.get("role") != "Admin":
        flash("Unauthorized", "danger")
        return redirect(url_for("users"))
    username = request.form.get("username")
    password = request.form.get("password")
    role = request.form.get("role")  # 'Staff' or 'Admin'
    try:
        call_proc_no_result('register_staff', (session.get("user_id"), username, password, role))
        flash("Staff/Admin account created.", "success")
    except Exception as e:
        flash(f"Failed to create staff/admin: {e}", "danger")
    return redirect(url_for("users"))

# ----------------
# Error page
# ----------------
@app.errorhandler(404)
def page_not_found(e):
    return render_template("error.html", message="Page not found."), 404

# ----------------
# Main
# ----------------
if __name__ == "__main__":
    app.run(debug=True)
