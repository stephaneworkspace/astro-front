<template>
  <div class="home">
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
