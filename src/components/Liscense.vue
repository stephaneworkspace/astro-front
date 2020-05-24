<template>
  <p>
    Cette page est à but non commercial pour ceux à qui ça interesse d'avoir des
    informations sur son thème astral. Le code source pour la génération de
    l'image vectorielle est disponible sur mon github et est écrit en Rust
    <a
      href="https://github.com/stephaneworkspace/astrology"
      target="_blank"
      rel="noopener"
      >code source</a
    >. Il est sous licence creative common. En revanche les éphémérides sont
    sous liscence GPL3. Ils se connectent à mon code source cité plus haut via
    un autre code source qui fait le pont entre la libraiaire C (swissephem
    d'astrodienst
    <a href="http://www.astro.com" target="_blank" rel="noopener"
      >astro.com (Astrodienst)</a
    >) et ce
    <a
      href="https://github.com/stephaneworkspace/libswe-sys"
      target="_blank"
      rel="noopener"
      >code source</a
    >
    ci en Rust.
  </p>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";

@Component({})
export default class InputData extends Vue {}
</script>
