# README

This application uses Rails Version 6.1.3.1 and SQLite3 database.

This application also uses Redis to maintain the User's cart information. Install Redis using `brew install redis` and run `redis-server` to start the Redis server.

# About

Freshcafe is a cafeteria management application build on Rails.

The application supports 3 user roles:

- Customer
- Billing Clerk
- Admin

## Roles of Customer

A customer can view the list of items and choose to add items to their cart. The items are segregated into categories for the users' convenience.

![Home](/screenshots/home.png)

Once an item is added to the cart, the user can increase/decrease the quantity of each item in their cart. If needed, the user can remove an item from their cart. 

The cart will display the total price and the individual price of each item in the cart. The user can place his order by clicking on the checkout button.

![Cart](/screenshots/cart.png)

A customer can also view all of his past orders from his profile page.

## Billing Clerk

In addition to the features that are accessible by the customer, A billing clerk can mark orders as delivered. When an order is placed, its default status is set to "Pending Delivery".

A user must be converted to a Billing Clerk by the admin.

## Admin

The admin has complete control over the application and its data.

- The admin can create new items.

- The admin can create new categories.

- The admin can view all the users in the application.

- The admin can convert other users to a billing clerk or another admin.

- The admin can delete user accounts.

- The admin can mark categories as inactive. This will prevent users to order items from that category until it's marked as active again.

- The admin can view reports of all the sales during a period.

- The admin can also mark orders as delivered.