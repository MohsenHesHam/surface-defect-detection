<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class VerificationCode extends Mailable
{
    use Queueable, SerializesModels;

    public $code;
    public $type;

    /**
     * Create a new message instance.
     *
     * @param string $code
     * @param string $type
     */
    public function __construct($code, $type = 'email')
    {
        $this->code = $code;
        $this->type = $type;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $subject = $this->type === 'email'
            ? 'Your Email Verification Code'
            : 'Your Phone Verification Code';

        return $this->subject($subject)
                    ->view('emails.verification')
                    ->with([ 'code' => $this->code ]);
    }
}
