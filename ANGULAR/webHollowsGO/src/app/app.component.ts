import {Router, RouterModule} from '@angular/router';
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  standalone: true,
  imports: [RouterModule]
})
export class AppComponent {
  isMuted: boolean = false;
  private audio!: HTMLAudioElement;

  constructor(private _router: Router) {}

  ngOnInit(): void {
    this.audio = new Audio('https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/MUSICA/ysqv9ww78jmpwijmb7qg');
    this.audio.loop = true;
    this.audio.autoplay = true;
    this.audio.volume = 0.5;
    this.audio.play().catch(err => console.warn('L\'àudio necessita interacció de l\'usuari a alguns navegadors:', err));
  }

  toggleMute(): void {
    this.isMuted = !this.isMuted;
    this.audio.muted = this.isMuted;
  }

  goToQuiSom(): void {
    this._router.navigate(['/qui-som']);
  }
  goToBleachInfo(): void {
    this._router.navigate(['/bleach-info']);
  }
  goToInici(): void {
    this._router.navigate(['..']);
  }
  goToHollowsGoInfo(): void {
    this._router.navigate(['/hollows-go-info']);
  }
}
