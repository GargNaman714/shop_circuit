const mongoose = require("mongoose");
const { productSchema } = require("./product");

// creating order schema: what all things an order should have
const orderSchema = mongoose.Schema({

    //all the products in the order, thats why made it an array
  products: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],

  //total price of the order
  totalPrice: {
    type: Number,
    required: true,
  },

  //address of the user who has placed the order
  address: {
    type: String,
    required: true,
  },

  //userID of the user who has placed the order
  userId: {
    required: true,
    type: String,
  },

  //time at which the order was placed
  orderedAt: {
    type: Number,
    required: true,
  },

  //status of the order, 0-->pending-->user has just placed the order, 2-->completed--> product is delivered form our side, 3-->recieved--> the user has tick-marked it, 4--> delivered--> both the parties have agreed that the order is well delivered and all is done
  status: {
    type: Number,
    default: 0,
  },
});

const Order = mongoose.model("Order", orderSchema);
module.exports = Order;