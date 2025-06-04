import { Routes } from '@angular/router';
import { IniciComponent } from './inici/inici';
import { QuiSomComponent } from './qui-som/qui-som';
import { BleachInfoComponent } from './bleach/bleach';
import {Hollowsgoinfo} from './hollowsgoinfo/hollowsgoinfo';

export const routes: Routes = [
  { path: '', component: IniciComponent },
  { path: 'qui-som', component: QuiSomComponent },
  { path: 'bleach-info', component: BleachInfoComponent },
  {path: 'hollows-go-info', component: Hollowsgoinfo},
  { path: '**', redirectTo: '' } // la ruta comodín SIEMPRE al final
];
