import {BrowserRouter,Route,Routes,Link} from 'react-router-dom';
import Home from './home.jsx';
import Contact from './contact.jsx';
import About from './about.jsx';
import './index.css';
import logo from './assets/logo.png';

export default function NavigationBar(){

  return(
    <div>
      <img src={logo} className="logo"/>
    <BrowserRouter className="navigation">
      <Link to="/home" className="navigation-elements">Home</Link>
      <Link to="/contact" className="navigation-elements">Contact Us</Link>
      <Link to="/about" className="navigation-elements">About</Link>  
    <Routes>
      <Route exact path="/home" element={<Home/>}/>
      <Route path="/contact" element={<Contact/>}/>
      <Route path="/about" element={<About/>}/>
    </Routes>
    </BrowserRouter>
    </div>
  );
}
