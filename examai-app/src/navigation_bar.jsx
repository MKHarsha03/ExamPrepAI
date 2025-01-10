import {BrowserRouter,Route,Routes,Link} from 'react-router-dom';
import Home from './home.jsx';
import Contact from './contact.jsx';
import About from './about.jsx';
import './index.css';

export default function NavigationBar(){

  return(
    <>
    <BrowserRouter>
    <nav className="navigation">
      <Link to="/home" className="navigation-elements">Home</Link>
      <Link to="/contact" className="navigation-elements">Contact Us</Link>
      <Link to="/about" className="navigation-elements">About</Link>  
    </nav>
    <Routes>
      <Route exact path="/home" element={<Home/>}/>
      <Route path="/contact" element={<Contact/>}/>
      <Route path="/about" element={<About/>}/>
    </Routes>
    </BrowserRouter>
    </>
  );
}
