import React from 'react';

// You can create components with functions or classes. In general, if you don't
// have to make it a class then don't. Home simply returns some JSX. JSX looks like
// HTML but it actually isn't. Not yet anyway. You'll notice subtle differences between 
// JSX and HTML like you have to use the className attribute instead of class since 
// "class" is a reserved word in JavaScript. But React ultimately converts JSX to HTML 
// through its ReactDOM.render method.
function Home() {
    return (
        <div className="jumbotron">
            <h1>Home Page</h1>
        </div>
    );
}

export default Home;
