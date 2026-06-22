import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LoanCalculator extends LightningElement {
    @track capitale;
    @track tasso;
    @track durata;
    @track risultato;

    handleCapitale(event) {
        this.capitale = parseFloat(event.target.value);
    }
    handleTasso(event) {
        this.tasso = parseFloat(event.target.value);
    }
    handleDurata(event) {
        this.durata = parseFloat(event.target.value);
    }

    calcolaRata() {
        if (!this.capitale || !this.tasso || !this.durata) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Errore',
                message: 'Compila tutti i campi prima di calcolare.',
                variant: 'error'
            }));
            return;
        }

        const tassoMensile = (this.tasso / 100) / 12;
        const rata = (this.capitale * tassoMensile) /
            (1 - Math.pow(1 + tassoMensile, -this.durata));
        this.risultato = rata.toFixed(2);
    }
}