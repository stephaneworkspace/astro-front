<template>
  <div id="app">
    <router-view />
  </div>
</template>

<style>
.logo {
  width: 622px;
  height: 300px;
}

.logo-bottom {
  width: 600px;
  heigth: 300px;
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
  color: #7957d5;
}

#nav a.router-link-exact-active {
  font-weight: bold;
  color: #7957d5;
  text-decoration: underline;
}
</style>
