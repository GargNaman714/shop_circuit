const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const User = require("../models/user");
const Order = require("../models/order");

//TIME_STAMP TITLE IN VIDEO:- ADDING TO CART  
//post api for adding to cart
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body; //get the id of the product which the user has just added to the cart
    const product = await Product.findById(id); //find the product by the id in DB
    let user = await User.findById(req.user); //find the user who has just added item in the cart. Here, we are able to get userID by writing--> req.user--> this is because we have used the 'auth' middleware

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      // check if the just added product is already in the same user's cart--> if yes--> increase the quantity of the product to be ordered by one  else add the product in the cart
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) { //comparing the productID of the product which the user has just entered with productIDs of all the products present int the user's cart already. Here, the type of IDs is 'ObjectId'--> this is a kind of data type in which MOngoDB stores the id of a document/record [check any document in MongoDB]
          isProductFound = true;
        }
      }

      if (isProductFound) {
        //find the product using the productID from the user's cart
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json(user); //return the user to client side. Now, also update the Provider in the client side
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//delete api for deleting products from user's cart. Called from cart_services.dart
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params; //fetch the ID of the product whose quantity count is to be reduced by one
    const product = await Product.findById(id); //find the product by the id in DB
    let user = await User.findById(req.user); //find the user who has just decremented the item count in the cart. Here, we are able to get userID by writing--> req.user. This is because we have used the 'auth' middleware

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1); //delete the product from user's cart 
        } else {
          user.cart[i].quantity -= 1; //decrement the product count
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//create a post request api to save the user's address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body; //fetch user's address
    let user = await User.findById(req.user); //find the user whose address is to be saved using userID. Here, we are able to get userID by writing--> req.user. This is because we have used the 'auth' middleware
    user.address = address; //edit/update user's address
    user = await user.save(); //save it to the DB
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//create a post request api to order products
userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body; //fetch cart.totalPrice and address
    let products = []; //create an empty array

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id); //fetch products form the user's cart and find them in th DB
      if (product.quantity >= cart[i].quantity) { //if the quantity in which the user has ordered a particulaf product is less tha or equal to the quantity of the same product in our store(jo seller/admin ne daali thi apna product add krte time ki iss product ki mere paas itni quantity hai) --> then proceed the transaction else say that the product is out of stock
        product.quantity -= cart[i].quantity; //decrease the quantity of the product in the seller's database by the quantity of the product the user has ordered
        products.push({ product, quantity: cart[i].quantity });
        await product.save(); //save to DB
      } else { 
        return res
          .status(400) //400 status code if for bad request 
          .json({ msg: `${product.name} is out of stock!` });
      }
    }

    let user = await User.findById(req.user); //find the user by userID. Here, we are able to get userID by writing--> req.user. This is because we have used the 'auth' middleware
    user.cart = []; //empty the user's cart as he has placed the order
    user = await user.save(); //save user to DB

    //create a new 'Order' object and upadte its values
    let order = new Order({
      products, //this is same as--> products:products. But since both of them have same name, therefore we can use this shorthand syntax
      totalPrice,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    order = await order.save(); //save the order to DB
    res.json(order); //return the order to client side.
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//create a get request api to fetch all orders of a particular order 
userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user }); //fetch the order of the user using userID. Here, we are able to get userID by writing--> req.user. This is because we have used the 'auth' middleware
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;