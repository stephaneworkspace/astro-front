<template>
  <div>
    <h3><strong>Vos coordonées</strong></h3>
    <section>
      <div class="form-astro">
        <div class="columns">
          <!--
          // This library as a problem with the format of date
          // and ergonomy
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
-->
          <div class="column">
            <b-field label="Jour de naissance">
              <b-input
                placeholder="Votre jour de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="dd"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Mois de naissance">
              <b-input
                placeholder="Votre n° de mois de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="mm"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Année de naissance">
              <b-input
                placeholder="Votre année de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="yyyy"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <!--
          // No good ergonomy
          <div class="column">
            <b-field label="Heure de naissance">
              <b-timepicker
                placeholder="Votre heure de naissance"
                icon="clock"
                size="is-medium"
                v-model="hhmm"
                @input="onChange"
              >
              </b-timepicker>
            </b-field>
          </div>
-->
          <div class="column">
            <b-field label="Heure de naissance">
              <b-input
                placeholder="Votre heure de naissance"
                icon="clock"
                size="is-medium"
                v-model="hh"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Minute de naissance">
              <b-input
                placeholder="Votre minute de naissance"
                icon="clock"
                size="is-medium"
                v-model="minute"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <!--
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
-->
        </div>
      </div>
      <InputGps
        :api="api"
        :swTransit="false"
        @change-lat-lng-offset="changeLatLngOffset"
      />
      <InputAspect :api="api" @change-aspect="updateAspect" />
    </section>
    <div v-if="show">
      <NatalChart :svg="svg" />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import NatalChart from "@/components/NatalChart.vue";
import InputAspect from "@/components/InputAspect.vue";
import InputGps from "@/components/InputGps.vue";
import moment from "moment";
const axios = require("axios").default;
//const moment = require("moment");
//moment().format();

@Component({
  components: {
    NatalChart,
    InputAspect,
    InputGps
  }
})
export default class InputData extends Vue {
  @Prop() private api!: string;
  public show = false;
  public valid = false;
  // public ddmmyyyy: Date = new Date();
  public yyyy: string = new Date().getFullYear().toString();
  public mm: string = (new Date().getMonth() + 1).toString();
  public dd: string = moment().format("DD");
  public hhmm: Date = new Date();
  public hh: string = new Date().getHours().toString();
  public minute: string = new Date().getMinutes().toString();
  public lat = 46.20222;
  public lng = 6.14569;
  public offset = 2.0;
  public svg = "";
  public aspectSelect = 0;

  public changeLatLngOffset(e) {
    this.lat = e.lat;
    this.lng = e.lng;
    this.offset = e.offset;
    this.svgNatal();
  }

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
    // console.log(this.ddmmyyyy);
    // const dateFinal = moment(this.ddmmyyyy, "DD/MM/YYYY");
    // const year = dateFinal.year();
    // const month = dateFinal.month();
    // const day = dateFinal.day();
    // const hour = parseInt(this.hhmm.getHours().toString(), 10);
    //  parseInt(this.offset.toString(), 10);
    // const min = parseInt(this.hhmm.getMinutes().toString(), 10);
    // console.log(moment());
    // console.log(moment().day());
    axios
      .post(
        this.api + "svg_chart",
        "year=" +
          parseInt(this.yyyy, 10) +
          "&month=" +
          parseInt(this.mm, 10) +
          "&day=" +
          parseInt(this.dd, 10) +
          "&hour=" +
          parseInt(this.hh, 10) +
          "&min=" +
          parseInt(this.minute, 10) +
          "&lat=" +
          this.lat +
          "&lng=" +
          this.lng +
          "&aspect=" +
          this.aspectSelect +
          "&time_zone=" +
          this.offset,
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
