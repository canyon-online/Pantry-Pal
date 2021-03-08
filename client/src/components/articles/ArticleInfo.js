import React, { useState, useEffect } from "react";

// The imports are the same as for ArticleList. The only thing to note is we are
// importing the whole Axios library rather than just the specific methods we are
// using (get and delete). That's because "delete" is a JavaScript reserved word.
// Since we're import the whole Axios library, we call the specific 
// methods with axios.get and axios.delete.
import axios from 'axios';
import { Link } from 'react-router-dom';

function ArticleInfo(props) {
    // Call the useState hook and set the value to a variable called article with
    // an initial state of an empty object {}. Assign the update function to the
    // variable name setArticle.
    const [article, setArticle] = useState({});
    
    // The useEffect hook is similar to ArticleList.
    useEffect(function() { 
        async function getArticle() {
            try {
                // This time we when we make our GET request to the API we need to send
                // the article id. So now the props object comes into play. If you look in the
                // Chrome Developer Tools "React" tab and search on ArticleList you'll see the
                // props and state objects in the pane to the right. Props contains three objects,
                // one of which is called Match. Match contains the path (articles/:_id), the url
                // (articles/id), and another object called params. Params contains a single path
                // param of :_id. So to get the article id we need to chain this all together
                //  with this.props.match.params._id.
                const response = await axios.get(`/api/articles/${props.match.params._id}`);

                // When the response to the AJAX request comes back we will use the setArticle
                // method to assign response data from the API to the
                // article object in the component's state.
                setArticle(response.data);
            } catch(error) {
                console.log('error', error);
            }
        }
        getArticle();
        // Adding props to the second argument of the useEffect hook instructs
        // React to re-run the effect if props changes.
    }, [props]); 

    // When the user clicks the "Delete" button, the onClick event calls the handleDelete handler function.
    async function handleDelete() { 
        try {
            // We use the Axios library to send a delete request to the provided URL.
            await axios.delete(`/api/articles/${props.match.params._id}`);

            // When we get a response from the delete request we will redirect to
            // the articles page using props.history.push("/articles").
            // We saw earlier in Chrome Dev Tools that the props contained
            // three objects: history, location, and match. The history object
            // contains a stack of the URL locations visited with the most recent on top,
            // including the current path at the very top. "Push" is a JavaScript method
            // that adds an item to the end of an array, so pushing the articles route
            // to the end (top) of the history stack will make that route the current location.
            props.history.push("/articles");
        } catch(error) {
            console.error(error);
        }
    }

    // The component returns the JSX which is converted to HTML.
    // It includes the article data and buttons for edit, delete and back.
    return (
    <div>
        <h2>{article.title}</h2>
        <small>_id: {article._id}</small>
        <p>{article.content}</p>
        <div className="btn-group">
            <Link to={`/articles/${article._id}/edit`} className="btn btn-primary">Edit</Link> 
            <button onClick={handleDelete} className="btn btn-danger">Delete</button> 
            <Link to="/articles" className="btn btn-secondary">Close</Link>
        </div>
        <hr/>
    </div>
    );
};

export default ArticleInfo;
