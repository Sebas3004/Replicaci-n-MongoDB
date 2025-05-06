const db = connect("mongodb://localhost:27017/socialTravelDB");

//Genera 5000 usuarios
for (let i = 1; i <= 5000; i++) {
    db.users.insertOne({
        user_id: i,
        username: "user" + i,
        email: "user" + i + "@example.com",
        password: "pass" + i,
        bio: "Traveler and adventurer #" + i
    });
}

//Genera 10,000 posts
for (let i = 1; i <= 10000; i++) {
    db.posts.insertOne({
        post_id: i,
        user_id: Math.floor(Math.random() * 5000) + 1,
        text: "Exploring amazing place #" + i,
        photo_links: ["https://example.com/photo" + i + ".jpg"],
        post_date: new Date()
    });
}

//Genera 50,000 comentarios
for (let i = 1; i <= 50000; i++) {
    db.comments.insertOne({
        comment_id: i,
        post_id: Math.floor(Math.random() * 10000) + 1,
        user_id: Math.floor(Math.random() * 5000) + 1,
        text: "Awesome trip! Comment #" + i,
        comment_date: new Date()
    });
}