<template>
  <div class="about">
    <img class="logo" alt="Top" src="../assets/logo.png" />
    <h1>
      Transit du thème astral gratuit avec la structure des maisons selon
      Placidus
    </h1>
    <div id="nav">
      <router-link to="/">Thème natal</router-link> |
      <router-link to="/transit">Transit</router-link>
    </div>
    <InputDataTransit api="https://www.astrologie-traditionnelle.net/api/" />
    <Liscense />
    <img class="logo-bottom" alt="Bottom" src="../assets/bottom.png" />
  </div>
</template>
<script>
// @ is an alias to /src
import InputDataTransit from "@/components/InputDataTransit.vue";
import Liscense from "@/components/Liscense.vue";

export default {
  name: "Transit",
  components: {
    InputDataTransit,
    Liscense
  }
};
</script>
