/**
 * Cloudinary Configuration
 * Using credentials from uploaded image
 */

export const CLOUDINARY_CONFIG = {
    cloudName: 'YOUR_CLOUD_NAME', // Get from Cloudinary dashboard
    apiKey: '986745973291359',
    apiSecret: '8Sz07OIof5-hYRHtYQzEyF70M',
    uploadPreset: 'skillswapp_reels', // Create this in Cloudinary settings
};

/**
 * Upload video to Cloudinary
 */
export async function uploadVideoToCloudinary(videoUri: string): Promise<{
    url: string;
    thumbnailUrl: string;
    duration: number;
}> {
    const formData = new FormData();

    formData.append('file', {
        uri: videoUri,
        type: 'video/mp4',
        name: `reel_${Date.now()}.mp4`,
    } as any);

    formData.append('upload_preset', CLOUDINARY_CONFIG.uploadPreset);
    formData.append('cloud_name', CLOUDINARY_CONFIG.cloudName);
    formData.append('api_key', CLOUDINARY_CONFIG.apiKey);

    try {
        const response = await fetch(
            `https://api.cloudinary.com/v1_1/${CLOUDINARY_CONFIG.cloudName}/video/upload`,
            {
                method: 'POST',
                body: formData,
                headers: {
                    'Accept': 'application/json',
                },
            }
        );

        const data = await response.json();

        if (!data.secure_url) {
            throw new Error('Upload failed: ' + (data.error?.message || 'Unknown error'));
        }

        return {
            url: data.secure_url,
            thumbnailUrl: data.secure_url.replace('/upload/', '/upload/so_0/'), // First frame
            duration: data.duration || 0,
        };
    } catch (error) {
        console.error('Cloudinary upload error:', error);
        throw new Error('Failed to upload video to cloud storage');
    }
}

/**
 * Upload image to Cloudinary (for thumbnails, course images, etc.)
 */
export async function uploadImageToCloudinary(imageUri: string): Promise<string> {
    const formData = new FormData();

    formData.append('file', {
        uri: imageUri,
        type: 'image/jpeg',
        name: `image_${Date.now()}.jpg`,
    } as any);

    formData.append('upload_preset', CLOUDINARY_CONFIG.uploadPreset);
    formData.append('cloud_name', CLOUDINARY_CONFIG.cloudName);

    try {
        const response = await fetch(
            `https://api.cloudinary.com/v1_1/${CLOUDINARY_CONFIG.cloudName}/image/upload`,
            {
                method: 'POST',
                body: formData,
            }
        );

        const data = await response.json();

        if (!data.secure_url) {
            throw new Error('Upload failed');
        }

        return data.secure_url;
    } catch (error) {
        console.error('Cloudinary image upload error:', error);
        throw new Error('Failed to upload image');
    }
}
