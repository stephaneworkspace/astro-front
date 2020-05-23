<template>
  <div id="app">
    <router-view />
    <br />
    <p>
      Cette page est à but non commercial pour ceux à qui ça interesse d'avoir
      des informations sur son thème astral. Le code source pour la génération
      de l'image vectorielle est disponible sur mon github et est écrit en Rust
      <a
        href="https://github.com/stephaneworkspace/astrology"
        target="_blank"
        rel="noopener"
        >code source</a
      >. Il est sous liscence creative common. En revanche les ephémérides sont
      sous liscence GPL3. Ils se connectent à mon source cité plus haut via un
      autre source ici qui fait le pont entre la libraiaire C (swissephem
      d'astrodientz
      <a href="astro.com" target="_blank" rel="noopener">astro.com</a>) et ce
      <a
        href="https://github.com/stephaneworkspace/libswe-sys"
        target="_blank"
        rel="noopener"
        >code source</a
      >
      ci en Rust.
    </p>
  </div>
</template>

<style>
.logo {
  width: 622px;
  height: 300px;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #7957d5;
  text-decoration: underline;
}
</style>
