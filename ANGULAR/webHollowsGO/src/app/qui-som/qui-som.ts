import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router, RouterModule } from '@angular/router';

@Component({
  selector: 'app-qui-som',
  templateUrl: './qui-som.html',
  styleUrls: ['./qui-som.css'],
  standalone: true,
  imports: [RouterModule],
})
export class QuiSomComponent implements OnInit, OnDestroy {
  constructor(private _router: Router) {
  }

  goInici(): void {
    this._router.navigate(['/']);
  }

  ngOnInit(): void {
    this.updateBackground();
    window.addEventListener('resize', this.updateBackground);
  }

  ngOnDestroy(): void {
    document.body.style.backgroundImage = '';
    document.body.style.backgroundColor = '';
    window.removeEventListener('resize', this.updateBackground);
  }

  updateBackground = () => {
    const isLandscape = window.matchMedia('(orientation: landscape)').matches;
    const imageUrl = isLandscape
      ? 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/cre3pjxh5xt44firil1k'
      : 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/e3wettuzovqwdicdhpmg';

    // 🔥 Sobrescribiendo directamente el fondo global
    document.body.style.setProperty('background-image', `url('${imageUrl}')`, 'important');
    document.body.style.setProperty('background-size', 'cover', 'important');
    document.body.style.setProperty('background-repeat', 'no-repeat', 'important');
    document.body.style.setProperty('background-position', 'center', 'important');
    document.body.style.setProperty('background-color', '#1b0c04', 'important');
  };
}
