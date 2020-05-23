<template>
  <div class="hello">
    <h3><strong>Vos coordonées</strong></h3>
    <section>
      <div class="form-astro">
        <div class="columns">
          <div class="column">
            <b-field label="Date de naissance">
              <b-datepicker
                placeholder="Votre date de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="ddmmyyyy"
                @input="onChange"
              >
              </b-datepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Heure de naissance">
              <b-timepicker
                placeholder="Votre heure de naissance"
                icon="clock"
                size="is-medium"
                v-model="hhmm"
                @input="onChange"
                editable
              >
              </b-timepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Fuseau horraire offset">
              <b-input
                placeholder="2 pour Genève"
                icon="clock"
                size="is-medium"
                v-model="offset"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Latitude">
              <b-input
                placeholder="Votre latitude de naissance"
                icon="compass"
                size="is-medium"
                v-model="lat"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Longitude">
              <b-input
                placeholder="Votre longitude de naissance"
                icon="compass"
                size="is-medium"
                v-model="lng"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
        </div>
        <div class="columns">
          <div class="column">
            <b-field label="Date du transit">
              <b-datepicker
                placeholder="Votre date de transit"
                icon="calendar-today"
                size="is-medium"
                v-model="ddmmyyyyTransit"
                @input="onChange"
              >
              </b-datepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Heure de transit">
              <b-timepicker
                placeholder="Votre heure de transit"
                icon="clock"
                size="is-medium"
                v-model="hhmmTransit"
                @input="onChange"
                editable
              >
              </b-timepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Fuseau horraire offseti transit">
              <b-input
                placeholder="2 pour Genève"
                icon="clock"
                size="is-medium"
                v-model="offsetTransit"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Latitude de transit">
              <b-input
                placeholder="Votre latitude de transit"
                icon="compass"
                size="is-medium"
                v-model="latTransit"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Longitude de transit">
              <b-input
                placeholder="Votre longitude de transit"
                icon="compass"
                size="is-medium"
                v-model="lngTransit"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
        </div>
      </div>
      <InputAspect :api="api" @change-aspect="updateAspect" />
      <!--
      <div class="column">
        <button class="button is-primary" v-on:click="svgNatal">
          Charger le thème astral
        </button>
      </div>
      -->
    </section>
    <div v-if="show">
      <NatalChart :svg="svg" />
    </div>
    <transition name="fade">
      <p v-if="show">bonjour</p>
      <p v-if="!show">aureveoir</p>
    </transition>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import NatalChart from "@/components/NatalChart.vue";
import InputAspect from "@/components/InputAspect.vue";
const axios = require("axios").default;

export interface DataObjectAspectSvg {
  svg: string;
  text: string;
  aspects: string[];
}

@Component({
  components: {
    NatalChart,
    InputAspect
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
  public ddmmyyyyTransit: Date = new Date();
  public hhmmTransit: Date = new Date();
  public offsetTransit = "2";
  public latTransit = 46.0222;
  public lngTransit = 6.14569;
  public svg = "";
  public aspectSelect = 0;

  public onChange() {
    this.svgNatal();
  }

  public updateAspect(e): void {
    this.aspectSelect = e;
    this.svgNatal();
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
          "&year_t=" +
          yearT +
          "&month_t=" +
          monthT +
          "&day_t=" +
          dayT +
          "&hour_t=" +
          hourT +
          "&min_t=" +
          minT +
          "&lat_t=" +
          this.latTransit +
          "&lng_t=" +
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
    this.svgNatal();
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
.form-astro {
  margin: 20px 20px 20px;
}
</style>
