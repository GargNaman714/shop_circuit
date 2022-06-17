const express=require('express');
const adminRouter=express.Router();  // ye isliye use krte hai taaki express ko dobra initialise na krna pade as we diid in index.js[const app= express();]
const admin=require("../middlewares/admin"); // this is the middleware
const { Product } = require("../models/product");
const Order = require("../models/order");


//ADD PRODUCT API
adminRouter.post("/admin/add-product",admin,async(req,res)=>{ //here, 'admin' is middleware
    try{
        const { name, description, images, quantity, price, category } = req.body; // const{...} --> these names should match with names in admin_services.dart file

        //now lets create the Product model
        let product=new Product({ // we didn't use 'const' data type here, We have used 'let'(dynamic data type) which allows us to store something else also in the variable later on(just like 'var')
            name,
            description,
            images,
            quantity,
            price,
            category,
        });
        
        //pehle hmne 'product' variable mein Product model ka ek instance store kiya tha upar(let product=new Product({})). Ab neeche wali line mein kya ho rha hai ki--> product k model ko MongoDB m save kr dia aur jo bhi MongoDb ne return kiya usse 'product' variablr m hi save kr lia coz wo 'const' type ka NAHI tha, dynamic type ka tha('let'). MongoDB ne _id and __version return kiya hoga jo ki hmne ab 'product' variable m rakh lia taaki usse hm sb client side m bhej sake.
        product=await product.save(); //save this product to DB
        res.json(product); //sending to client side
    }catch(e){
        res.status(500).json({error:e.message});
    }
})


//GET ALL YOUR PRODUCTS API(/admin/get-products)
//since we just need to fetch data and display it on the screen, therefore use GET method instead of POST method
adminRouter.get("/admin/get-products", admin, async (req, res) => { //here, 'admin' is middleware
    try {
      const products = await Product.find({}); // get all the products from the DB(it returns a list/array of Documents). Here we r fetching all the products without any filter/criteria. TO fetch documents based on certain criteria --> EG: fetch all  the products with price=20000 ==> const products= Product.find({price:2000});
      res.json(products); // return to the client(front-end). It will return a list of documents(Products) in JSON format
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
});

//DELETE THE PRODUCT API
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
    try {
      const { id } = req.body; //grab the id from req.body
      //now find the product and delete it
      let product = await Product.findByIdAndDelete(id);
      res.json(product); // send the product that was deleted to the client-side(frontEnd)
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  //FETCH ALL ORDERS API. Ffetch all orders to admin screen to dispaly all the orders placed by users to the admin to initiate deliveries
  adminRouter.get("/admin/get-orders", admin, async (req, res) => {
    try {
      const orders = await Order.find({}); //get all the orders from DB(it returns a list/array of Documents)
      res.json(orders); //return all orders to Client-Side
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  

  //create a post api request so that the admin can change order status of orders placed by users which will be displayed on the screen using Stepper()[FLutter] widget
  adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body; //get the order whose status is to be updated and the status which which the order-status is to be updated
    let order = await Order.findById(id); //find that order in DB by using orderID
    order.status = status; //update the  status
    order = await order.save(); //save the order
    res.json(order); //send back to the client side
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//create a get api request to find totoal and category-wise earnings. This will be shown in 'analytics' bottom navigation bar in the admin interface
adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({}); //get all the orders from DB(it returns a list/array of Documents)
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      }
    }
    // CATEGORY WISE ORDER FETCHING
    let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings); //return the 'earnings' variable to the client side
  } catch (e) { 
    res.status(500).json({ error: e.message });
  }
});

//creating an async function to get category-wise products
async function fetchCategoryWiseProduct(category) { //here, 'category' is argument to this function. In JS we dont really need to specify the data type of the argument as it is a dynamically typed language
  let earnings = 0;

  //"categoryOrders" is a list/array of type 'Order'. It will contain the Order objects where "products.product.category"=='category' received as argument
  let categoryOrders = await Order.find({ //watch video--> 10:50:40
    "products.product.category": category,
  }); 

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
  return earnings;
}

//the authRouter variable can be used in this file only. In order to make it accessible to others as well --> export it
// we should make sure that our route is connected to index.js
module.exports=adminRouter;


//agar multiple variables export krne ho to, then we export objects
// EG: module.exports={adminRouter,name:"naman"}; //adminRouter:adminRouter likhte tabhi bhi chalta, it is just short-hand when the key and value have same name

