<template>
  <div class="home">
    <img class="logo" alt="Vue logo" src="../assets/logo.png" />
    <div id="nav">
      <router-link to="/">Thème natal</router-link> |
      <router-link to="/transit">Transit</router-link>
    </div>
    <h1>
      Thème astral gratuit avec la structure des maisons selon Placidus
    </h1>
    <InputData api="https://www.astrologie-traditionnelle.net/api/" />
  </div>
</template>

<script>
// @ is an alias to /src
import InputData from "@/components/InputData.vue";

export default {
  name: "Home",
  components: {
    InputData
  }
};
</script>
