import { Routes } from '@angular/router';
import { IniciComponent } from './inici/inici';
import { QuiSomComponent } from './qui-som/qui-som'
export const routes: Routes = [
  { path: '', component: IniciComponent },
  { path: 'qui-som', component: QuiSomComponent },
  { path: '**', redirectTo: '' }
];

