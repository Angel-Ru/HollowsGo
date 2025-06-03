import { Component } from '@angular/core';
import {Router, RouterModule} from '@angular/router'; // ¡Importa Router, no RouterModule!

@Component({
  selector: 'app-qui-som',
  templateUrl: './qui-som.html',
  styleUrls: ['./qui-som.css'],
  standalone: true,
  imports: [RouterModule]
})
export class QuiSomComponent {
  constructor(private _router: Router) {} // ¡Necesitas inyectar Router!

  goInici(): void {
    this._router.navigate(['/qui-som']);
  }
}
