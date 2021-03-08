// React components require the React library. Additionally, import useState and
// useEffect to use the State and Effect hooks. Read Hooks at a Glance for a quick summary. 
import React, { useState, useEffect } from 'react';

// To access data from the API we'll make an AJAX get request using the Axios package we added earlier.
import axios  from 'axios';

// We will include links to the the individual Article pages and to the New Article form, 
// so import the Link component from the react-router-dom module.
import { Link } from 'react-router-dom';

// Declare the ArticleList functional component.
function ArticleList() {
    // Set the initial state of our component to an empty array with the useState hook.
    // UseState is a two element array that contains the current state as the first 
    // element and a function to update it as the second. Here we're assigning the (const)
    // variable "articles" to the current state value, and "setArticles" to the update function.
    const [articles, setArticles] = useState([])

    // UseEffect essentially replaces the lifecycle methods (componentDidMount, componentDidUpdate, componentWillUnmount).
    // Place your asynchronous code here such as your API call. Code in the useEffect 
    // method runs after the initial render of the component and changes the state of the component.
    useEffect(function() {
        // The API call is asynchronous since it sends a get request to 
        // the API and waits for a response from the server.
        async function getArticles() {
            // We're using the Axios library to make an AJAX get request and convert
            // the JSON response to a JavaScript object. We aren't including the
            // domain part of the URL -- http://localhost:3001 -- because we added
            // it as a proxy in the package.json file.
            try {
                const response = await axios.get("/api/articles");
                // Call the setArticles method to change the articles state,
                // passing in the response object we got back from the API
                // (which is an array of article objects). The React useState
                // hook will change the articles state to this object.
                setArticles(response.data);
            } catch(error) {
            console.log('error', error);
            }
        }
        getArticles();
        // The useEffect hook takes a second argument that instructs React to
        // rerun the effect. We only want to run the effect once to get the list
        // of articles so just set it to an empty array.
    }, []);

    // React components return JSX which is converted to HTML.
    return (
        <div>
            <h2>
                Articles
                <Link to="/articles/new" className="btn btn-primary float-right">Create Article</Link> 
            </h2>
            <hr/>
            {
                // Access the articles state object which is an array of the article
                // objects we got from the API. The JavaScript map method iterates though
                // the array transforming each item based on the function provided and
                // returning a new transformed array.
            articles.map((article) => {
            // React requires that we assign a unique key to each item when iterating though a list, so we are assigning the article id attribute.
            return(
                <div key={article._id}>
                    <h4><Link to={`/articles/${article._id}`}>{article.title}</Link></h4>
                    <small>_id: {article._id}</small>
                    <hr/>
                </div>
            )
            })}
            <Link to="/articles/new" className="btn btn-outline-primary">Create Article</Link>
        </div>
    )
}

export default ArticleList;
