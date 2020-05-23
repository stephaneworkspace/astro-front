<template>
  <div class="hello">
    <h1>
      Votre thème astral gratuit en français avec la structure des maisons selon
      Placidus
    </h1>
    <h3><strong>Vos coordonées</strong></h3>
    <section>
      <div class="form_astro">
        <div class="columns">
          <div class="column">
            <!--
              :date-formatter="dateFormatter"
              :date-parser="dateParser"
              :date-creator="dateCreator"
            -->
            <b-field label="Date de naissance">
              <b-datepicker
                v-model="ddmmyyyy"
                placeholder="Votre date de naissance"
                icon="calendar-today"
                size="is-medium"
              >
              </b-datepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Heure de naissance">
              <b-timepicker
                v-model="hhmm"
                placeholder="Votre heure de naissance"
                icon="clock"
                size="is-medium"
                editable
              >
              </b-timepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Fuseau horraire offset">
              <b-input
                v-model="offset"
                placeholder="2 pour Genève"
                icon="clock"
                size="is-medium"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Latitude">
              <b-input
                v-model="lat"
                placeholder="Votre latitude de naissance"
                icon="compass"
                size="is-medium"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Longitude">
              <b-input
                v-model="lng"
                placeholder="Votre longitude de naissance"
                icon="compass"
                size="is-medium"
              >
              </b-input>
            </b-field>
          </div>
        </div>
      </div>
      <div class="column">
        <!--<b-button type="is-primary" @click="svg_natal"
          >Charger le thème astral</b-button
        >-->
        <button class="button is-primary" v-on:click="svgNatal">
          Charger le thème astral
        </button>
      </div>
    </section>
    <NatalChart v-if="show" svg="svg" />
    <p>
      Cette page est à but non commercial pour ceux a qui ça interesse d'avoir
      des informations sur son thème astral. Le code source pour la génération
      de l'image vectorielle est disponible sur mon github et est écrit en Rust
      <a
        href="https://github.com/stephaneworkspace/astrology"
        target="_blank"
        rel="noopener"
        >code source</a
      >. Il est sous liscence creative common. En revanche les ephémérides sont
      sous liscence GPL3. Ils se connectent a mon source cité plus haut via un
      autre source ici qui fait le pont entre la libraiaire C (swissephem
      d'astrodientz
      <a href="astro.com" target="_blank" rel="noopener">astro.com</a>) et ce
      <a
        href="https://github.com/stephaneworkspace/lib-swe"
        target="_blank"
        rel="noopener"
        >code source</a
      >
      ci en Rust.
    </p>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import NatalChart from "@/components/NatalChart.vue";
const axios = require("axios").default;
/*
const dateFormatter = {
  type: Function,
  required: false,
  default: date => date.toLocaleDateString()
};
const dateParser = {
  type: Function,
  required: false,
  default: date => new Date(Date.parse(date))
};
const dateCreator = {
  type: Function,
  required: false,
  default: () => new Date()
};
const today = new Date();
// Not work... to do later or with another frontend with a more documented
// framework...
const minDate = {
  type: Function,
  required: false,
  default: () =>
    new Date(today.getFullYear() - 300, today.getMonth(), today.getDate())
};
const maxDate = {
  type: Function,
  required: false,
  default: () =>
    new Date(today.getFullYear() + 300, today.getMonth(), today.getDate())
};
*/
@Component({
  components: {
    NatalChart
  }
})
export default class InputData extends Vue {
  @Prop() private api!: string;
  public show = false;
  public valid = false;
  public ddmmyyyy: Date = new Date();
  public hhmm: Date = new Date();
  public offset = "2";
  public lat = 46.0222;
  public lng = 6.14569;
  public svg!: string;
  public svgNatal(): void {
    const config = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    const year = this.ddmmyyyy.getFullYear();
    const month = this.ddmmyyyy.getMonth();
    const day = this.ddmmyyyy.getDay();
    const hour =
      parseInt(this.hhmm.getHours().toString(), 10) +
      parseInt(this.offset.toString(), 10);
    const min = parseInt(this.hhmm.getMinutes().toString(), 10);
    axios
      .post(
        this.api,
        "year=" +
          year +
          "&month=" +
          month +
          "&day=" +
          day +
          "&hourf32=0.0&hour=" +
          hour +
          "&min=" +
          min +
          "&lat=" +
          this.lat +
          "&lng=" +
          this.lng,
        config
      )
      .then(res => {
        this.svg = res.data;
        this.$forceUpdate();
      });
    this.show = true;
  }

  private created() {
    this.show = false;
    /*
    const config = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    axios
      .post(
        this.api,
        "year=2000&month=1&day=1&hourf32=1.1&hour=1&min=1",
        config
      )
      .then(res => {
        this.svg = res.data;
        this.$forceUpdate();
      });
*/
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  font-size: 24px;
  margin: 20px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
.form_astro {
  margin: 20px 20px 20px;
}
.boxes {
  display: -webkit-flex;
  justify-content: center;
  height: 100%;
}
.chart {
  width: 600px;
  height: 600px;
}
</style>
