<template>
  <div class="home">
    <img class="logo" alt="Top" src="../assets/logo.png" />
    <h1>
      Thème astral gratuit avec la structure des maisons selon Placidus
    </h1>
    <div id="nav">
      <router-link to="/">Thème natal</router-link> |
      <router-link to="/transit">Transit</router-link>
    </div>
    <InputData api="/api/" />
    <Liscense />
    <img class="logo-bottom" alt="Bottom" src="../assets/bottom.png" />
  </div>
</template>

<script>
// @ is an alias to /src
import InputData from "@/components/InputData.vue";
import Liscense from "@/components/Liscense.vue";

export default {
  name: "Home",
  components: {
    InputData,
    Liscense
  }
};
</script>
