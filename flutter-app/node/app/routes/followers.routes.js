module.exports = app => {
  const followers = require("../controllers/followers.controller.js");

  
  app.post("/followers", followers.create);

  app.get("/isFollowing/:autoId/:annonceurId", followers.isFollowing);

  app.get("/getFollowers/:annonceurId", followers.getFollowers);

  app.get("/getToken/:autoId", followers.getToken);

  app.delete("/followers/:autoId/:annonceurId", followers.delete);
  
};