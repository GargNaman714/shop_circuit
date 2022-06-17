const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token)
      return res.status(401).json({ msg: "No auth token, access denied" }); //401 statusCode is for unauthorized access

    const verified = jwt.verify(token, "passwordKey");
    if (!verified)
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });

    req.user = verified.id; // we are adding a new object to this req and that is: 'user'
    req.token = token; //we are adding a new object to this req and that is: 'token'
    next(); // auth.js file which is in routes folder, usme getData wali api m use kiya hai 'auth' middleware -->  authRouter.get("/", auth, async (req, res) => {. Ab agr hm ye next() nahi lilkhenge to execution async(req,res) mein nhi pahuchegi and thats not what we want
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = auth;