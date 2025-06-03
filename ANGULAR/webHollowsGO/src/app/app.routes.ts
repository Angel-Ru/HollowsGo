import { Routes } from '@angular/router';
import { IniciComponent } from './inici/inici';
import { QuiSomComponent } from './qui-som/qui-som';
import { BleachInfoComponent } from './bleach/bleach';

export const routes: Routes = [
  { path: '', component: IniciComponent },
  { path: 'qui-som', component: QuiSomComponent },
  { path: 'bleach-info', component: BleachInfoComponent },
  { path: '**', redirectTo: '' } // la ruta comodín SIEMPRE al final
];
