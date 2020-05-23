<template>
  <div class="hello">
    <h3><strong>Vos coordonées</strong></h3>
    <section>
      <div class="form_astro">
        <div class="columns">
          <div class="column">
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
        <div class="columns">
          <div class="column">
            <b-field label="Date du transit">
              <b-datepicker
                v-model="ddmmyyyyTransit"
                placeholder="Votre date de transit"
                icon="calendar-today"
                size="is-medium"
              >
              </b-datepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Heure de transit">
              <b-timepicker
                v-model="hhmmTransit"
                placeholder="Votre heure de transit"
                icon="clock"
                size="is-medium"
                editable
              >
              </b-timepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Fuseau horraire offseti transit">
              <b-input
                v-model="offsetTransit"
                placeholder="2 pour Genève"
                icon="clock"
                size="is-medium"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Latitude de transit">
              <b-input
                v-model="latTransit"
                placeholder="Votre latitude de transit"
                icon="compass"
                size="is-medium"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Longitude de transit">
              <b-input
                v-model="lngTransit"
                placeholder="Votre longitude de transit"
                icon="compass"
                size="is-medium"
              >
              </b-input>
            </b-field>
          </div>
        </div>
      </div>
      <div v-if="showAspects">
        <label class="label">Aspects</label>
        <div class="aspect_text">
          {{ aspects[aspectSelect].text }}
        </div>
        <div class="columns">
          <div v-for="(aspect, i) in aspects" :key="aspect.text" class="column">
            <div
              class="aspect_svg_select"
              v-html="aspect.svg"
              @click="clickAspect(i)"
            />
          </div>
        </div>
      </div>
      <div class="column">
        <button class="button is-primary" v-on:click="svgNatal">
          Charger le thème astral
        </button>
      </div>
    </section>
    <div v-if="show">
      <NatalChart :svg="svg" />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import NatalChart from "@/components/NatalChart.vue";
const axios = require("axios").default;

export interface DataObjectAspectSvg {
  svg: string;
  text: string;
  aspects: string[];
}

@Component({
  components: {
    NatalChart
  }
})
export default class InputData extends Vue {
  @Prop() private api!: string;
  public show = false;
  public showAspects = false;
  public valid = false;
  public ddmmyyyy: Date = new Date();
  public hhmm: Date = new Date();
  public offset = "2";
  public lat = 46.0222;
  public lng = 6.14569;
  public ddmmyyyyTransit: Date = new Date();
  public hhmmTransit: Date = new Date();
  public offsetTransit = "2";
  public latTransit = 46.0222;
  public lngTransit = 6.14569;
  public svg = "";
  public aspectSelect = 0;
  public aspects: DataObjectAspectSvg[] = [];
  public clickAspect(i): void {
    this.aspectSelect = i;
  }
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
    const yearT = this.ddmmyyyyTransit.getFullYear();
    const monthT = this.ddmmyyyyTransit.getMonth();
    const dayT = this.ddmmyyyyTransit.getDay();
    const hourT =
      parseInt(this.hhmmTransit.getHours().toString(), 10) +
      parseInt(this.offsetTransit.toString(), 10);
    const minT = parseInt(this.hhmmTransit.getMinutes().toString(), 10);
    axios
      .post(
        this.api + "svg_chart_transit",
        "year=" +
          year +
          "&month=" +
          month +
          "&day=" +
          day +
          "&hour=" +
          hour +
          "&min=" +
          min +
          "&lat=" +
          this.lat +
          "&lng=" +
          this.lng +
          "&yearT=" +
          yearT +
          "&monthT=" +
          monthT +
          "&dayT=" +
          dayT +
          "&hourT=" +
          hourT +
          "&minT=" +
          minT +
          "&latT=" +
          this.latTransit +
          "&lngT=" +
          this.lngTransit +
          "&aspect=" +
          this.aspectSelect,
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
    this.getAspects();
  }

  private getAspects() {
    const config = {
      "Content-Type": "application/json"
    };
    axios.get(this.api + "aspects.json", config).then(res => {
      this.aspects = res.data;
      this.showAspects = true;
    });
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  font-size: 24px;
  margin: 10px 0 0;
}
a {
  color: #7957d5;
}
.form_astro {
  margin: 20px 20px 20px;
}
.aspect_text {
  justify-content: center;
}
.aspect_svg_select {
  width: 27px;
  height: 27px;
  margin: 27px;
  background: transparent;
}
.aspect_svg {
  width: 40px;
  height: 40px;
  margin: 40px;
  background: transparent;
}
</style>
