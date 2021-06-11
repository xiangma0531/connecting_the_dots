const menu = () => {
  const menuTrigger = document.getElementById("menu_trigger");
  const menu = document.getElementById("session_menu");

  menuTrigger.addEventListener('click', () => {
    if (menu.getAttribute("style") == "display:block;" ) {
      menu.removeAttribute("style", "display:block;")
    } else {
      menu.setAttribute("style", "display:block;")
    }
  });
};

window.addEventListener('load', menu)