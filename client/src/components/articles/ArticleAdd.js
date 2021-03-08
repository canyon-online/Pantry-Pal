// In our React imports we will only be using the useState hook.
// For our Axios imports we'll be using a post request.
import React, { useState } from "react";
import { post } from 'axios';

function ArticleAdd(props) {
    const initialState = { title: '', content: '' }
    // Our useState hook will create a state named article with initial state set
    // to an object with title and content properties set to empty strings.
    // We'll also set the function for updating state to variable "setArticle".
    const [article, setArticle] = useState(initialState)

    // Every time a user types a character in a form input field the onChange property
    // calls the handleChange handler function passing the event object as an implicit argument.
    // The event object includes the target (i.e., the form field element) which
    // has attributes for field name and value. The handleChange function in turn
    // calls setArticle which updates the article state with the new value.
    // You need to include the ...article spread operator so that the new character
    // is added to the existing article value, otherwise it will just overwrite it.
    // You can see the process in action by adding console.log(event.target);
    // to the handleChange function then look at the console after typing in a character.
    // You can also look at the React tab in the console after drilling down to the ArticleAdd
    // component and you will see State update after every key is pressed.
    function handleChange(event) { 
        setArticle({...article, [event.target.name]: event.target.value})
    }

    // When the user clicks the form's submit button, it triggers the onClick event
    // which calls the handleSubmit handler function.
    function handleSubmit(event) {
        // Normally when an HTML form is submitted a new page is called.
        // Since we are sending the data via AJAX and don't want to be sent to
        // a new page we need add preventDefault().
        event.preventDefault();
        // We add a conditional that checks if either of the form fields are empty.
        // If they are we stop the function by returning nothing. 
        if (!article.title || !article.content) return
            async function postArticle() {
            try {
                // We'll sent a POST request to the API endpoint sending the current state.
                const response = await post('/api/articles', article);
                // Then using ES6 promises, when the new article is returned we'll
                // use the response.data object to get the id so we can redirect
                // to the correct ArticleInfo route.
                props.history.push(`/articles/${response.data._id}`);
            } catch(error) {
            console.log('error', error);
            }
        }
        postArticle();
    }

    function handleCancel() {
        props.history.push("/articles");
    }

    // Our return statement is the JSX for our form. Each form field element has
    // properties for name, value(set to the article state) and onClick set to a
    // handler function. The form element has an onSubmit property set to a handler
    // function that is triggered when the user clicks the submit button.
    return ( 
    <div>
        <h1>Create Article</h1>
        <hr/>
        <form onSubmit={handleSubmit}>
        <div className="form-group">
            <label>Title</label>
            <input name="title" type="text" value={article.title} onChange={handleChange} className="form-control" />
        </div>
        <div className="form-group">
            <label>Content</label>
            <textarea name="content" rows="5" value={article.content} onChange={handleChange} className="form-control" />
        </div>
        <div className="btn-group">
            <input type="submit" value="Submit" className="btn btn-primary" />
            <button type="button" onClick={handleCancel} className="btn btn-secondary">Cancel</button>
        </div>
        </form>
    </div>
    );
}

export default ArticleAdd;
